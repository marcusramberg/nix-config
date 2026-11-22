{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ../../modules/pipewire.nix
    ../../nixos/calibre-web.nix
  ];

  # Bootloader.
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.limine.efiInstallAsRemovable = true;
    # Setup keyfile
    initrd = {
      secrets = {
        "/hdd.key" = "/var/lib/secrets/hdd.key";
      };
      luks.devices = {
        "luks-0050060b-f9cb-4697-8934-aef2f5ad0e2a" = {
          device = "/dev/disk/by-uuid/0050060b-f9cb-4697-8934-aef2f5ad0e2a";
          keyFile = "/hdd.key";
        };
        "luks-cc871eb9-17d2-4e3a-a779-7f830d1f4065" = {
          device = "/dev/disk/by-uuid/cc871eb9-17d2-4e3a-a779-7f830d1f4065";
          keyFile = "/hdd.key";
        };
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = lib.mkOrder 1500 [
      # VT-d is enabled in firmware; the kernel still wants this to drive the
      # IOMMU (required for PCI passthrough).
      "intel_iommu=on"
      # Override Jovian's dcdebugmask=0x20000 (plane-flash workaround): it
      # floods dmesg with "HDR SB:" lines, drowning out the pstore crash
      # captures. Last value on the cmdline wins.
      "amdgpu.dcdebugmask=0x0"
      # Default mask + the OverDrive bit (0x4000): exposes gpu_od/fan_ctrl
      # for the quieter fan thresholds set by amdgpu-quiet-fans below.
      "amdgpu.ppfeaturemask=0xfff7ffff"
    ];
    # These modules are required for PCI passthrough, and must come before early modesetting stuff
    kernelModules = [
      "fbcon"
      "hid-apple"
      "kvm-intel"
      # fan RPM / board voltages on the B760's NCT6687D Super I/O;
      # MSI boards aren't in the driver's whitelist, hence force
      "nct6683"
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 2048576; # default: 8192
      "fs.inotify.max_user_instances" = 1024; # default: 128
      "fs.inotify.max_queued_events" = 32768; # default: 16384 };

      # Crash forensics for the random freezes: turn silent lockups into
      # panics so efi-pstore captures a dmesg dump we can read after reboot
      # (ls /sys/fs/pstore). Remove once the freeze is diagnosed.
      "kernel.sysrq" = 1; # allow Alt+SysRq+{s,u,b} / +c from a frozen console
      "kernel.softlockup_panic" = 1;
      "kernel.hardlockup_panic" = 1;
      "kernel.panic_on_oops" = 1;
      "kernel.panic" = 30; # reboot 30s after panic, pstore write happens first
    };
    extraModprobeConfig = ''
      options hid_apple iso_layout=1
      options kvm_intel nested=1
      options nct6683 force=1
    '';
  };
  environment.systemPackages = with pkgs; [
    heroic
    # lutris # FIXME: temp disable as build is broken
    wine
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/026028f5-9639-4140-ae09-010c05dfa3c6";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1CB4-F73F";
      fsType = "vfat";
    };
    "/space" = {
      device = "mspace:/volume1/space";
      fsType = "nfs4";
      options = [
        "nfsvers=4.1"
        "soft"
        "x-systemd.automount"
        "noauto"
      ];
    };
    "/mnt/nix" = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_1TB_S5H9NS0R223863N-part1";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=nix"
      ];
    };
    "/var/lib/llama-models" = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_1TB_S5H9NS0R223863N-part1";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=llama-models"
      ];
    };
    "/home/marcus/Games" = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_1TB_S5H9NS0R223863N-part1";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=games"
      ];
    };
    "/home/marcus/org" = {
      device = "mspace:/volume1/homes/marcus/Drive/orgmode";
      fsType = "nfs4";
      options = [
        "nfsvers=4.1"
        "soft"
        "x-systemd.automount"
        "noauto"
      ];
    };
  };

  jovian = {
    decky-loader = {
      enable = true;
      user = "marcus";
    };
    hardware.has.amd.gpu = true;
    steamos = {
      enableBluetoothConfig = true;
      enableSysctlConfig = true;
    };
    steam = {
      enable = true;
      user = "marcus";
      autoStart = true;
      desktopSession = "niri";
    };
  };

  networking = {
    hostName = "mbox";
    networkmanager.enable = true;
    # whisper user services for Balder (8178 nb-whisper, 8179 large-v3-turbo); opened at runtime via nixos-fw temp-ports until the next rebuild
    firewall.allowedTCPPorts = [
      8178
      8179
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    gpu.amd.enable = true;
    bluetooth.enable = true;
    keyboard.dual-caps.enable = true;
    # Log MCE/PCIe-AER hardware errors persistently (freeze diagnosis)
    rasdaemon.enable = true;
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/a3e364f4-a757-4e71-b220-5c850de97136"; } ];

  profiles = {
    desktop = {
      enable = true;
      displayManager = false;
    };
    dockerHost.enable = true;
    gaming.enable = true;
    gradientWorker = {
      enable = true;
      id = "2a3fc017-43f1-4a05-948e-e7fb3035205c";
    };
    incus.enable = true;
    limine.enable = true;
    caddy = {
      enable = true;
      configFile = ../../config/Caddyfile.mbox;
    };
    k3s = {
      enable = false;
      serverAddr = "https://192.168.86.1:6443";
      staticIP = {
        enable = true;
        ip = "192.168.86.22";
      };
    };
  };

  programs = {
    custom.ddcutil = {
      enable = true;
      user = "marcus";
    };
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility"; # For systems with AMD GPUs
          # card0 is the 14700K's iGPU on the B760 board; the AMD dGPU is card1
          gpu_device = 1;
          amd_performance_level = "high";
        };
      };
    };
    steam.remotePlay.openFirewall = true;
  };

  services = {
    blueman.enable = true;
    immich = {

      enable = true;
      database = {
        createDB = true;
        enable = true;
      };
      host = "0.0.0.0";
      mediaLocation = "/space/immich";
      openFirewall = true;
      secretsFile = config.age.secrets.immich.path;
    };
    prometheus.exporters.node.enable = true;
    jellyfin.enable = true;
    k3s.clusterInit = true;
    monado = {
      enable = true;
      # package = inputs.monado.packages.${pkgs.stdenv.hostPlatform.system}.default;
      #   package = pkgs.monado.overrideAttrs {
      #     src = pkgs.fetchFromGitHub {
      #       owner = "DMJC";
      #       repo = "monado-psvr2";
      #       rev = "d1c38abf995c8b44620727825ce1c0fb061d47ee";
      #       sha256 = "sha256-eebD5GgE4u38AWx8sxuRrY0aiy4ndgyztSxkJZYtCmw=";
      #     };
      defaultRuntime = true;
    };

    llama-swap = {
      enable = true;
      listenAddress = "0.0.0.0";
      port = 8081;
      openFirewall = true;
      settings = {
        logLevel = "debug";
        models =
          let
            modelsDir = "/var/lib/llama-models";
            llamaCpp = pkgs.llama-cpp.override { vulkanSupport = true; };
            llamaServer = lib.getExe' llamaCpp "llama-server";
            # Inkling 2's looped-layer arch (inkling2_loop) needs llama.cpp master
            # (merged upstream 2026-11-20, not in the 0.9.0 release).
            # NB: use ggml-org's GGUFs; unsloth's claim block_count=48 with only
            # 24 blocks of tensors and don't load in upstream builds.
            llamaServerInkling = lib.getExe' (llamaCpp.overrideAttrs (old: {
              version = "0.9.0-master-inkling2";
              src = pkgs.fetchFromGitHub {
                owner = "ggml-org";
                repo = "llama.cpp";
                rev = "29b52d398b294509746ec0a3f28948a3107c0213"; # master 2026-11-20
                hash = "sha256-6CcMhIEw2JzuQgAZqk0RnGuIXZ7/g4ofjLbQu9LRQAE=";
              };
              # master has no tools/ui webui, which nixpkgs 0.9.0 builds with npm
              npmDeps = null;
              npmRoot = null;
              preConfigure = "";
              nativeBuildInputs = lib.filter (h: (h.name or "") != "npm-config-hook") old.nativeBuildInputs;
              doCheck = false; # test-kv-cache-scales needs pytorch
            })) "llama-server";
            mkCmd = args: lib.concatStringsSep " " (lib.filter (a: a != "") args);
          in
          {
            "qwen-3.6-fable" = {
              cmd = mkCmd [
                "${llamaServer}"
                "--port \${PORT}"
                "-m ${modelsDir}/Qwen3.6-27B-Fable-Fus-711-UnHeretic-NM-DAU-NEO-MAX-NEO-AMD-MTP-IQ4_XS.gguf"
                "--mmproj ${modelsDir}/mmproj-qwen.gguf"
                "-ngl 99"
                "-fa on"
                "-np 1"
                "--spec-type draft-mtp"
                "--spec-draft-n-max 2"
                "-c 70000"
                "--cache-ram 10000"
                "-ctxcp 2"
                "--jinja"
                "--temp 0.6"
                "--top-p 0.95"
                "--top-k 20"
                "--min-p 0.0"
                "--presence-penalty 0.0"
                "--repeat-penalty 1.0"
                "--reasoning on"
                # "--chat-template-kwargs '{" preserve_thinking ": true}'"
              ];
            };
            "Qwen3.8-27B" = {
              cmd = mkCmd [
                "${llamaServer}"
                "--port \${PORT}"
                "-m ${modelsDir}/Qwen3.8-27B-Q4_K_M.gguf"
                "--mmproj ${modelsDir}/mmproj-qwen.gguf"
                "--fit on"
                "-ngl 99"
                "-fa on"
                "-np 1"
                "--spec-type draft-mtp"
                "--spec-draft-n-max 2"
                "-c 70000"
                "--cache-ram 10000"
                "-ctxcp 2"
                "--jinja"
                "--temp 0.6"
                "--top-p 0.95"
                "--top-k 20"
                "--min-p 0.0"
                "--presence-penalty 0.0"
                "--repeat-penalty 1.0"
                "--reasoning off"
                # "--chat-template-kwargs '{" preserve_thinking ": true}'"
              ];
            };
            "borealis2-26b-a4b" = {
              cmd = mkCmd [
                "${llamaServer}"
                "--port \${PORT}"
                "-m ${modelsDir}/borealis2-26b-a4b-preview-Q4_K_M.gguf"
                "--mmproj ${modelsDir}/mmproj_borealis2-26b-a4b-preview-bf16.gguf"
                "--fit on"
                "-ngl 99"
                "-fa on"
                "-np 1"
                "-c 70000"
                "--cache-ram 10000"
                "-ctxcp 2"
                "--jinja"
                "--temp 1.0"
                "--top-p 0.95"
                "--top-k 64"
                "--min-p 0.0"
                "--presence-penalty 0.0"
                "--repeat-penalty 1.0"
                "--reasoning off"
              ];
            };
            "inkling-2-mini" = {
              cmd = mkCmd [
                "${llamaServerInkling}"
                "--port \${PORT}"
                "-m ${modelsDir}/Inkling-2-Mini-IQ4_NL.gguf"
                "--mmproj ${modelsDir}/mmproj-Inkling-2-Mini-BF16.gguf"
                "-ngl 99"
                "-np 1"
                "-c 80000"
                "--jinja"
                "--temp 1.0"
                "--top-p 1.0"
                "--top-k 0"
                "--min-p 0.0"
                # reasoning can't be fully disabled on inkling; keep it from
                # eating the client's max_tokens budget before the answer
                "--reasoning-effort low"
                "--reasoning-budget 2048"
              ];
            };
          };
      };
    };

    tailscale.useRoutingFeatures = "server";
    woodpecker-agents.agents.mbox = {
      enable = true;
      environment = {
        WOODPECKER_SERVER = "passthrough:///ci-agent.bas.es:443";
        WOODPECKER_GRPC_SECURE = "true";
        WOODPECKER_BACKEND = "docker";
        DOCKER_HOST = "unix:///run/docker.sock";
        WOODPECKER_AGENT_LABELS = "!builder=x86,builder=x86";
        WOODPECKER_AGENT_CONFIG_FILE = "/var/lib/woodpecker/agent_config.yaml";
      };
      extraGroups = [ "podman" ];
      environmentFile = [ config.age.secrets.woodpecker-ci.path ];
    };
  };
  systemd.services = {
    # Quieter 7900 XTX: lower the firmware fan controller's acoustic
    # thresholds (needs amdgpu.ppfeaturemask OD bit, see kernelParams).
    # These are soft targets — the card still throttles clocks before
    # overheating, so worst case is reduced boost, never damage. Valid
    # ranges are printed inside the sysfs files; if a write is rejected
    # the service fails visibly and the firmware defaults stay active.
    amdgpu-quiet-fans = {
      description = "Lower amdgpu acoustic fan RPM thresholds";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        for ctrl in /sys/class/drm/card*/device/gpu_od/fan_ctrl; do
          [ -e "$ctrl/acoustic_target_rpm_threshold" ] || continue
          echo 1050 > "$ctrl/acoustic_target_rpm_threshold"
          echo c > "$ctrl/acoustic_target_rpm_threshold"
          echo 1900 > "$ctrl/acoustic_limit_rpm_threshold"
          echo c > "$ctrl/acoustic_limit_rpm_threshold"
        done
      '';
    };

    "woodpecker-agent-mbox".serviceConfig = {
      StateDirectory = "/var/lib/woodpecker";
      ReadWritePaths = [ "/var/lib/woodpecker" ];
    };

    NetworkManager-wait-online = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.networkmanager}/bin/nm-online -q"
        ];
      };
    };
    glance = {
      enable = true;
      description = "Glance";
      unitConfig = {
        Type = "simple";
      };
      serviceConfig = {
        ExecStart = "${pkgs.glance}/bin/glance --config /var/lib/glance/glance.yaml";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
  systemd = {
    # Arm the iTCO hardware watchdog: if the kernel dies so hard that even
    # NMI panic can't fire, the board resets itself after 30s instead of
    # hanging until the power button. A watchdog reboot (vs. a pstore dump)
    # also tells us the kernel was completely dead, not just the GPU.
    settings.Manager.RuntimeWatchdogSec = "30s";
    user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      WMR_HANDTRACKING = "0";

    };
  };
  users.users.caddy.extraGroups = [ "incus-admin" ];
  virtualisation = {
    libvirtd.enable = true;
    waydroid.enable = true;
  };
}
