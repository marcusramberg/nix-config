{ pkgs, lib, ... }:
let
  # kdePackages.callPackage, not pkgs.callPackage: this is a Qt6/KF6 app, and
  # qtbase, kcoreaddons, ki18n and layer-shell-qt only exist in that scope.
  # The second argument is not optional either -- callPackage without it yields
  # a function rather than a package, which systemPackages rejects.
  tastiera = pkgs.kdePackages.callPackage ../../packages/tastiera { };
in
{
  imports = [

    ../../nixos/dmsmobile.nix
  ];
  documentation.nixos.enable = false;
  environment = {
    variables.GTK_IM_MODULE = lib.mkForce "wayland";
    sessionVariables.WLR_RENDER_DRM_DEVICE = "/dev/dri/by-path/platform-1f000000.gpu-render"; # panthor, stable across probe order
    systemPackages = with pkgs; [
      hunspell
      hunspellDicts.en-us
      tastiera
    ];
  };

  hardware = {
    keyboard.dual-caps.enable = true;
    keyboard.dual-caps.swapAlt.enable = true;
    pixel9pro = {
      audio.enable = true;
      display.enable = true;
      modem = {
        enable = true;
        modemManager = true;
      };
      sensors.enable = true;
      wifi = {
        enable = true;
        driver = "brcmfmac"; # TEMP: btc_mode A/B for the wl2 trap, AGENTS.md §3
      };
    };
    sensor.iio.enable = true;

  };

  # Gotta shut this off until we get proper early drm
  boot.plymouth.enable = false;

  # Debug boots burn generations fast and the volume-key menu is the only way
  # back to a good one.
  #
  # The old "3, not 5, because each specialisation is a ~58M UKI" reasoning was
  # wrong: measured at limit 3 with two specialisations, /boot is 112M of 499M
  # and /boot/EFI/nixos is 56M in total -- systemd-boot shares one kernel and
  # initrd across every entry instead of copying them per generation. Space is
  # not the constraint, so this is 5: DP bring-up has cost several resets in a
  # row, and 3 is one bad boot away from having no known-good entry left.
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 5;

  # Debug entries for the ABL -> U-Boot direct-boot hang (no uniLoader shim).
  # Specialisations rather than plain kernelParams: these are useless-to-harmful
  # on a normal boot, and the volume-key menu is the only way back, so they get
  # their own systemd-boot entries. Both append to the parent cmdline -- for
  # every parameter here the kernel takes the LAST occurrence, so appending is
  # enough to override what the normal boot sets.
  #
  # Read the log off the panel (keep_bootcon + a camera). That is the only
  # channel that has worked every time. ramoops is unreliable here: it records
  # fine (/dev/pmsg0 and /sys/fs/pstore exist on a running system) and has
  # produced content before, but on 2026-09-09 it read all-zero after both a
  # watchdog reset and a panic=10 reboot. Check it, never plan around it.
  # specialisation = {
  #   # Informational boot log. NOT initcall_debug -- we already know the hang is
  #   # armv8_pmu_driver_init; what is missing is the GIC/PSCI/SMP block just
  #   # above it, and initcall_debug buries that under thousands of lines.
  #   #
  #   # ignore_loglevel is the actual fix: the normal cmdline sets loglevel=4, so
  #   # only KERN_ERR and above reach the console. That is why a direct-boot photo
  #   # shows nothing but the -22 probe failures -- every informational line
  #   # (GICv3, psci, "Booted secondary processor", "smp: Brought up N CPUs") was
  #   # filtered out and never displayed. They print immediately before the
  #   # initcalls, since smp_init() runs before do_basic_setup().
  #   #
  #   # Compare against the working uniLoader boot:
  #   #   psci: PSCIv1.1 detected in firmware. / SMC Calling Convention v1.2
  #   #   GICv3: 960 SPIs implemented
  #   #   GICv3: GICD_CTLR.DS=0, SCR_EL3.FIQ=1
  #   #   smp: Brought up 1 node, 8 CPUs
  #   #
  #   # KEEP nmi_watchdog=panic here. A hang can only be escaped with a long
  #   # power press, which cuts DRAM and takes ramoops with it -- so a silent hang
  #   # yields nothing at all. A panic both prints the stuck CPU's stack and warm
  #   # resets into U-Boot with the ramoops region intact, which is the only way a
  #   # log has ever been recovered from this device.
  #   #
  #   # watchdog_thresh is left at its default. Raising it to 60 was to stop
  #   # initcall_debug's flood tripping the detector on the working path, but
  #   # initcall_debug is gone and ignore_loglevel alone is far quieter. It also
  #   # backfired: with the default threshold the wedge was detected ~69s after it
  #   # happened, so 60 pushes that out to many minutes and looks like "no panic".
  #   directboot-debug.configuration = {
  #     # mkOrder 2000: dmsmobile.nix appends its set at mkOrder 1600, including
  #     # nmi_watchdog=panic. The kernel takes the last occurrence, so these have
  #     # to sort after it or the override silently does nothing.
  #     boot.kernelParams = lib.mkOrder 2000 [
  #       "ignore_loglevel"
  #       "nmi_watchdog=panic"
  #
  #       # Deliberately no initcall_blacklist: exynos_drm_init must run, since
  #       # whether the DPU quiesce still hangs is the thing being tested.
  #       #
  #       # keep_bootcon, or the efifb console is dropped at ~1.47s when tty1
  #       # registers and the panel shows nothing after it -- which is how the
  #       # DECON hang stayed invisible for a whole session.
  #       "keep_bootcon"
  #
  #       # Auto-escape rather than a power press, since the at24 stall at ~16s is
  #       # the expected next failure if the quiesce fix works. Nothing kicks the
  #       # watchdog before userspace, so a wedge resets in ~30s.
  #       "s3c2410_wdt.tmr_atboot=1"
  #       "s3c2410_wdt.tmr_margin=30"
  #     ];
  #
  #     # Hand the watchdog to systemd once userspace is up, so a boot that now
  #     # succeeds stays up to be ssh'd into instead of resetting 30s in.
  #     systemd.settings.Manager.RuntimeWatchdogSec = "20s";
  #   };
  #
  #   # Get a shell on the direct path. Everything else is downstream of that:
  #   # dmesg, /proc/interrupts and devmem on the GIC, diffable against a working
  #   # uniLoader boot, instead of another photograph-and-ramoops cycle.
  #   #
  #   # keep_bootcon is what made any of this visible. The kernel drops the efifb
  #   # boot console the moment tty1 registers (~1.47s), and tty1 at that point is
  #   # the dummy 80x25 console -- nothing repaints the panel until a real fb
  #   # driver binds. Every direct-boot photo before 2026-09-09 ended at exactly
  #   # that line and said nothing about where the kernel actually died.
  #   #
  #   # Three failures were found on the direct path. The first is fixed; this
  #   # entry skips the other two to reach userspace:
  #   #
  #   #   exynos_drm_init       -- FIXED. The DPU quiesce SRESET stalled the CPU on
  #   #                            the DECON's AXI slave when the DECON was already
  #   #                            idle on entry (GLOBAL_CON 0x133 direct vs 0x113
  #   #                            via uniLoader, one bit: IDLE_STATUS, and already
  #   #                            set that way in U-Boot). See
  #   #                            dpu-quiesce-skip-sreset-when-idle-on-entry.patch.
  #   #   armv8_pmu_driver_init -- open. smp_call_function_any waits on a CSD that
  #   #                            a *different* CPU never runs; CPU0 is not in that
  #   #                            PMU instance's supported_cpus. All 8 CPUs are up
  #   #                            (measured), so this is not "no secondaries".
  #   #   at24 2-0050           -- open. Probe stalls the CPU. Skipped via the DT
  #   #                            below, since EEPROM_AT24=y.
  #   #
  #   # One comma-separated value if a second initcall is ever added here: the
  #   # kernel takes the last occurrence of initcall_blacklist=, so repeating the
  #   # parameter drops the first.
  #   directboot-shell.configuration = {
  #     boot.kernelParams = lib.mkOrder 2000 [
  #       # exynos_drm_init and pd_ignore_unused dropped 2026-09-09: the DPU
  #       # quiesce hang is fixed (dpu-quiesce-skip-sreset-when-idle-on-entry), so
  #       # DRM runs here now. Three failures were found on this path; this entry
  #       # skips the two that are still open, to reach userspace and finally get
  #       # /proc/interrupts and the IPI counters.
  #       "initcall_blacklist=armv8_pmu_driver_init"
  #       "ignore_loglevel"
  #       "keep_bootcon"
  #       # at24 2-0050 is skipped via the DT below, not here: EEPROM_AT24=y, so
  #       # modprobe.blacklist cannot touch it.
  #
  #       # DECON0 GLOBAL_CON is NOT deterministic on the direct path: 0x133
  #       # (idle on entry) and 0x113 (mid-frame) have both been seen across
  #       # boots. dpu-quiesce-skip-sreset-when-idle-on-entry.patch only covers
  #       # the first, and the SRESET still stalls the CPU when the boot happens
  #       # to land on the second -- so the honest statement is that SRESET hangs
  #       # on this path however it got there.
  #       #
  #       # quiesce_boot_decon=0 skips the quiesce entirely (module_param in
  #       # exynos_dpu_dma.c; the Makefile object is exynosdrm-y, hence the
  #       # prefix). Not free: the quiesce exists because enabling SysMMU
  #       # translation under a live DMA master resets the SoC, so the expected
  #       # failure without it is a reset rather than a hang. Both outcomes are
  #       # informative and it costs no rebuild.
  #       "exynosdrm.quiesce_boot_decon=0"
  #
  #       # Escape from a wedge without a power press. s3c2410-wdt probes at
  #       # ~15.6s, ahead of the at24 stall at ~16.5s, so arming it at probe covers
  #       # the remaining failures. Nothing kicks it before userspace, so the SoC
  #       # resets ~30s later.
  #       #
  #       # Do NOT expect a log out of that reset: ramoops read back all-zero after
  #       # a watchdog reset *and* after a panic=10 reboot on 2026-09-09, though it
  #       # has produced content on earlier occasions. It records fine
  #       # (/dev/pmsg0 and /sys/fs/pstore both exist); the data is just often gone
  #       # by the time U-Boot looks. keep_bootcon plus a camera is the channel
  #       # that has worked every time.
  #       "s3c2410_wdt.tmr_atboot=1"
  #       "s3c2410_wdt.tmr_margin=30"
  #     ];
  #
  #     # Without this a *successful* boot resets 30s in too, since nothing would
  #     # kick the watchdog. systemd takes it over once userspace is up, so a wedge
  #     # before that still resets while a working boot stays up.
  #     systemd.settings.Manager.RuntimeWatchdogSec = "20s";
  #
  #     # Third failure on the direct path. at24's probe stalls the CPU, and
  #     # EEPROM_AT24=y so modprobe.blacklist cannot reach it -- the node has to go
  #     # from the DT. Scoped here so the daily driver keeps the EEPROM.
  #     hardware.pixel9pro.directBoot.skipEeprom = true;
  #   };
  #
  #   # Read the early boot off the panel instead of recovering it afterwards.
  #   #
  #   # Every log-recovery route is closed: the SoC watchdog resets without
  #   # preserving DRAM (ramoops read back all-zero immediately after one, while
  #   # /dev/pmsg0 and /sys/fs/pstore prove ramoops itself records fine), and no
  #   # software detector can fire on a single-CPU non-sleeping stall.
  #   #
  #   # boot_delay is ms per printk, capped at 10000 by boot_delay_setup(). At 500
  #   # the panel shows ~2 lines/sec, so the first screenful stays readable for
  #   # most of a minute -- and "smp: Brought up 1 node, N CPUs" is in the first
  #   # ~50 lines, far ahead of any of the hangs. Needs CONFIG_BOOT_PRINTK_DELAY,
  #   # which was UNSET until 2026-09-09; the parameter silently did nothing before.
  #   #
  #   # No initcall_blacklist here on purpose: this entry is for reading the
  #   # pristine early boot, and it never needs to survive long enough to reach
  #   # the DECON, PMU or at24 hangs. Power it off once the photo is taken.
  #   directboot-early.configuration = {
  #     boot.kernelParams = lib.mkOrder 2000 [
  #       "ignore_loglevel"
  #       "keep_bootcon"
  #       "boot_delay=500"
  #     ];
  #   };
  #
  # };

  # Don't block boot ~9.5s waiting for wifi (ath11k rproc probe defers wlan0 late).
  systemd.services.NetworkManager-wait-online.enable = false;

  nix = {
    buildMachines = [
      {
        system = "aarch64-linux";
        sshUser = "marcus";
        hostName = "mstudio";
        protocol = "ssh-ng";
        supportedFeatures = [
          "kvm"
          "nixos-test"
          "big-parallel"
          "benchmark"
        ];
        maxJobs = 4;
      }
    ];
    settings = {
      max-jobs = 0;
    };
  };
  profiles = {
    dmsMobile.enable = true;
    myfonts.enable = true;
  };
  services = {
    desktopManager = {
      gnome.enable = true;
    };
  };
}
