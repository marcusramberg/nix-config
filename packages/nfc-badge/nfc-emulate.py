#!/usr/bin/env python3
"""
Prototype NFC-A listen / card-emulation driver for the Fairphone 5 (ST21NFCD).

Drives the CLF in raw NCI over the /dev/st21nfc_raw passthrough exposed by the
st21nfc_nci kernel driver. The kernel NCI core must be DOWN (nfc0 disabled)
before running this -- opening the raw node while nfcX is up returns -EBUSY.

Sequence: CORE_RESET -> CORE_INIT -> CORE_SET_CONFIG(listen A) ->
RF_DISCOVER(listen NFC-A). When an external reader energises the field and
selects us, the CLF emits RF_INTF_ACTIVATED_NTF in listen mode; we log it.
The card presents whatever NFCID1 the CLF generates (a 4-byte random UID by
default, first byte 0x08) unless --uid is given. Configure the door reader to
accept that UID (or accept-any).

This is a bring-up tool: it proves listen mode works and shows the activation.
It does not implement a full Type-2 tag (no READ/WRITE responses) -- readers
that only take the UID from anticollision do not need that.

Usage:
    nfc0 down first:  nfctool --device nfc0 --disable   (as root)
    sudo ./nfc-emulate.py [--uid 08:aa:bb:cc] [--verbose]
"""

import argparse
import os
import select
import sys
import time

DEV = "/dev/st21nfc_raw"
# First byte must not be 0x08 (ISO 14443-3 reserves it for random IDs -- the
# CLF regenerates the UID on every activation) nor 0x88 (cascade tag).
DEFAULT_UID = [0x04, 0x11, 0x22, 0x33]

# NCI message types (top 3 bits of byte 0)
MT_CMD = 0x20
MT_RSP = 0x40
MT_NTF = 0x60

# GIDs
GID_CORE = 0x00
GID_RF = 0x01
GID_PROP = 0x0F

# Core OIDs
CORE_RESET = 0x00
CORE_INIT = 0x01
CORE_SET_CONFIG = 0x02

# RF OIDs
RF_DISCOVER_MAP = 0x00
RF_DISCOVER = 0x03
RF_INTF_ACTIVATED = 0x05
RF_DEACTIVATE = 0x06

# RF tech-and-mode
NFC_A_PASSIVE_LISTEN = 0x80

# SET_CONFIG parameter IDs (NCI listen-A)
LA_BIT_FRAME_SDD = 0x30
LA_PLATFORM_CONFIG = 0x31
LA_SEL_INFO = 0x32
LA_NFCID1 = 0x33

STATUS_OK = 0x00

# Type-2 tag commands (arrive as NCI data packets on conn 0 via the Frame RF
# interface; the NFCC handles CRC in both directions).
T2T_READ = 0x30
T2T_WRITE = 0xA2
T2T_SECTOR_SEL = 0xC2
T2T_ACK = 0x0A
T2T_NAK = 0x00


def t2t_image(uid):
    """64-byte static Type-2 memory: UID/BCC, CC, and an empty NDEF TLV."""
    mem = bytearray(64)
    mem[0:4] = bytes(uid[:4])
    mem[4] = uid[0] ^ uid[1] ^ uid[2] ^ uid[3]
    mem[12:16] = bytes([0xE1, 0x10, 0x06, 0x00])  # CC: NDEF, v1.0, 48 bytes, RW
    mem[16:19] = bytes([0x03, 0x00, 0xFE])  # empty NDEF TLV + terminator
    return mem


def hx(b):
    return " ".join("%02x" % x for x in b)


class Clf:
    def __init__(self, verbose=False):
        self.fd = os.open(DEV, os.O_RDWR)
        self.verbose = verbose
        self.poller = select.poll()
        self.poller.register(self.fd, select.POLLIN)

    def close(self):
        os.close(self.fd)

    def send_data(self, payload, conn=0):
        frame = bytes([conn, 0x00, len(payload)]) + bytes(payload)
        if self.verbose:
            print("TX data %s" % hx(frame))
        os.write(self.fd, frame)

    def send(self, mt, gid, oid, payload=b""):
        hdr = bytes([mt | gid, oid, len(payload)])
        frame = hdr + payload
        if self.verbose:
            print("TX %s" % hx(frame))
        os.write(self.fd, frame)

    def drain(self, timeout=0.6):
        """Read and discard any unsolicited frames (e.g. the CLF's boot
        notification after reset). The ST CLF NAKs a host write while its IRQ
        is asserted, so pending frames must be consumed before the first CMD."""
        got = 0
        while True:
            f = self.recv(timeout=timeout)
            if f is None:
                return got
            got += 1
            if self.verbose:
                print("drained %s" % hx(f))

    def recv(self, timeout=1.0):
        """Return one NCI frame (bytes) or None on timeout."""
        deadline = time.monotonic() + timeout
        while True:
            rem = deadline - time.monotonic()
            if rem <= 0:
                return None
            if not self.poller.poll(rem * 1000):
                return None
            frame = os.read(self.fd, 260)
            if not frame:
                continue
            if self.verbose:
                print("RX %s" % hx(frame))
            return frame

    def expect(self, mt, gid, oid, timeout=1.0):
        """Wait for a specific frame, skipping proprietary notifications."""
        end = time.monotonic() + timeout
        while time.monotonic() < end:
            f = self.recv(timeout=end - time.monotonic())
            if f is None or len(f) < 3:
                continue
            f_mt, f_gid = f[0] & 0xE0, f[0] & 0x0F
            f_oid = f[1]
            # Silently drop the CLF's proprietary power/field-monitor stream.
            if f_gid == GID_PROP:
                continue
            if f_mt == mt and f_gid == gid and f_oid == oid:
                return f
            if self.verbose:
                print("  (ignored %s)" % hx(f[:3]))
        return None


def core_reset(clf):
    # NCI 2.0 CORE_RESET_CMD: ResetType 0x01 = reset configuration.
    clf.send(MT_CMD, GID_CORE, CORE_RESET, bytes([0x01]))
    rsp = clf.expect(MT_RSP, GID_CORE, CORE_RESET, timeout=1.5)
    if not rsp or rsp[3] != STATUS_OK:
        raise RuntimeError("CORE_RESET failed: %s" % (hx(rsp) if rsp else "timeout"))
    # NCI 2.0 also emits CORE_RESET_NTF with version info.
    ntf = clf.expect(MT_NTF, GID_CORE, CORE_RESET, timeout=1.0)
    if ntf and len(ntf) >= 6:
        print("CLF NCI version 0x%02x, manufacturer 0x%02x" % (ntf[4], ntf[5]))


def core_init(clf):
    # NCI 2.0 CORE_INIT_CMD payload: 2 bytes (feature enables), both zero.
    clf.send(MT_CMD, GID_CORE, CORE_INIT, bytes([0x00, 0x00]))
    rsp = clf.expect(MT_RSP, GID_CORE, CORE_INIT, timeout=1.5)
    if not rsp or rsp[3] != STATUS_OK:
        raise RuntimeError("CORE_INIT failed: %s" % (hx(rsp) if rsp else "timeout"))
    print("CORE_INIT ok (rsp %d bytes)" % len(rsp))
    return rsp


def set_listen_config(clf, uid=None):
    # Build a CORE_SET_CONFIG with the listen-A parameters. SEL_INFO 0x00
    # advertises no ISO-DEP/NFC-DEP, so a reader takes us as a plain NFC-A
    # target and reads the UID from anticollision.
    params = []

    def tlv(pid, val):
        params.append(bytes([pid, len(val)]) + val)

    tlv(LA_BIT_FRAME_SDD, bytes([0x08]))
    tlv(LA_PLATFORM_CONFIG, bytes([0x00]))
    tlv(LA_SEL_INFO, bytes([0x00]))
    if uid is not None:
        tlv(LA_NFCID1, bytes(uid))

    payload = bytes([len(params)]) + b"".join(params)
    clf.send(MT_CMD, GID_CORE, CORE_SET_CONFIG, payload)
    rsp = clf.expect(MT_RSP, GID_CORE, CORE_SET_CONFIG, timeout=1.5)
    if not rsp:
        raise RuntimeError("SET_CONFIG timeout")
    # rsp: Status, num_invalid_params, [param_ids...]
    if rsp[3] != STATUS_OK:
        bad = rsp[5:] if len(rsp) > 5 else b""
        raise RuntimeError("SET_CONFIG rejected params: %s (status 0x%02x)"
                           % (hx(bad), rsp[3]))
    print("SET_CONFIG ok")


def rf_discover_listen(clf):
    # RF_DISCOVER_CMD: num entries, then (tech_and_mode, frequency) pairs.
    # One entry: NFC-A passive listen, frequency 1.
    payload = bytes([1, NFC_A_PASSIVE_LISTEN, 0x01])
    clf.send(MT_CMD, GID_RF, RF_DISCOVER, payload)
    rsp = clf.expect(MT_RSP, GID_RF, RF_DISCOVER, timeout=1.5)
    if not rsp or rsp[3] != STATUS_OK:
        raise RuntimeError("RF_DISCOVER failed: %s" % (hx(rsp) if rsp else "timeout"))
    print("RF_DISCOVER (listen NFC-A) started")


def t2t_respond(clf, mem, p):
    if not p:
        return
    cmd = p[0]
    if cmd == T2T_READ and len(p) >= 2:
        # READ returns 4 blocks, wrapping at the end of the memory area.
        start = (p[1] * 4) % len(mem)
        clf.send_data(bytes(mem[(start + i) % len(mem)] for i in range(16)))
    elif cmd == T2T_WRITE and len(p) >= 6:
        off = (p[1] * 4) % len(mem)
        mem[off:off + 4] = p[2:6]
        clf.send_data(bytes([T2T_ACK]))
    elif cmd == T2T_SECTOR_SEL:
        clf.send_data(bytes([T2T_NAK]))
    else:
        # Stay silent rather than NAK: a NAK makes the reader retransmit, and
        # an unknown command is more likely us mis-framing than a real error.
        print("unhandled T2T cmd %s" % hx(p))


def parse_uid(s):
    parts = s.replace(":", " ").split()
    return [int(p, 16) for p in parts]


def main():
    ap = argparse.ArgumentParser()
    # Fixed by default: a door reader has to enrol a stable UID, and a random
    # one would change on every activation.
    ap.add_argument("--uid", type=parse_uid, default=DEFAULT_UID,
                    help="NFCID1 to present, e.g. 08:aa:bb:cc")
    ap.add_argument("--verbose", action="store_true", help="dump raw NCI traffic")
    args = ap.parse_args()

    try:
        clf = Clf(verbose=args.verbose)
    except OSError as e:
        sys.exit("open %s failed: %s (is nfc0 disabled? EBUSY means nfcX is up)"
                 % (DEV, e))

    try:
        # The CLF was reset when the raw node opened; drain its boot
        # notification before the first command or the write will NAK.
        clf.drain(timeout=0.6)
        core_reset(clf)
        core_init(clf)
        set_listen_config(clf, uid=args.uid)
        rf_discover_listen(clf)

        print("Listening as UID %s. Present phone to a reader (Ctrl-C to stop)..."
              % hx(args.uid))
        mem = t2t_image(args.uid)
        while True:
            f = clf.recv(timeout=5.0)
            if f is None:
                continue
            mt, gid, oid = f[0] & 0xE0, f[0] & 0x0F, f[1]
            if mt == 0x00:
                t2t_respond(clf, mem, f[3:])
                continue
            if gid == GID_PROP:
                # A reader that only takes the UID is answered by the CLF's own
                # anticollision, so this field/power monitor stream is the only
                # sign anything happened.
                print("[%.3f] prop %s" % (time.monotonic(), hx(f)))
                continue
            if mt == MT_NTF and gid == GID_RF and oid == RF_INTF_ACTIVATED:
                print(">>> ACTIVATED in listen mode (reader selected us)")
                print("    %s" % hx(f))
            elif mt == MT_NTF and gid == GID_CORE and oid == 0x06:
                continue  # CORE_CONN_CREDITS_NTF
            elif mt == MT_NTF and gid == GID_RF and oid == RF_DEACTIVATE:
                print("<<< deactivated (reader left field)")
            else:
                print("NTF %s" % hx(f))
    except KeyboardInterrupt:
        print("\nstopping")
    finally:
        clf.close()


if __name__ == "__main__":
    main()
