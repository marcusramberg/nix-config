{ lib, pkgs, osConfig, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  isDesktop = isNixOS && osConfig.services.xserver.enable;

in {
  gtk = mkIf isDesktop {
    enable = true;
    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
    };
  };
  programs.i3status-rust = mkIf isDesktop {
    enable = true;
    bars = {
      status = {
        theme = "nord-dark";
        icons = "material-nf";
        blocks = [
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "cpu";
            format = " $utilization ";
          }
          {
            block = "temperature";
            format = " $icon ";
            format_alt = " $icon $max ";
          }
          {
            block = "memory";
            format = " $icon$mem_used.eng(p:Mi) ";
            format_alt = " $icon_swap $swap_used.eng(p:Mi) ";
          }

          {
            block = "sound";
            format = " $icon $output_name {$volume.eng(w:2) |}";
            click = [{
              button = "left";
              cmd = "pavucontrol --tab=3";
            }];
            mappings = {
              "alsa_output.pci-0000_00_1f.3.iec958-stereo" = "";
              "bluez_sink.70_26_05_DA_27_A4.a2dp_sink" = "";
            };
          }
          {
            block = "time";
            format = " $icon $timestamp.datetime(f:'%R') ";
          }
        ];
      };
    };
  };
  services.gpg-agent = mkIf stdenv.isLinux {
    enable = pkgs.stdenv.isLinux;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
}
