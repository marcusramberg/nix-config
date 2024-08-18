{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;
  isNixOS = lib.hasAttr "nixos" osConfig.system;
  isDesktop = isNixOS && osConfig.services.xserver.enable;

in
{
  gtk = mkIf isDesktop {
    enable = true;
    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
    };
  };
  programs.i3status-rust = mkIf stdenv.isLinux {
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
            format = " $icon$mem_used.eng(p:Mi) s";
            format_alt = " $icon_swap $swap_used.eng(p:Mi) ";
          }

          {
            block = "sound";
            format = " $icon $output_name {$volume.eng(w:2) |}";
            click = [
              {
                button = "left";
                cmd = "pavucontrol --tab=3";
              }
            ];
            mappings = {
              "alsa_output.pci-0000_00_1f.3.iec958-stereo" = "";
              "alsa_output.pci-0000_00_01.0.analog-stereo" = "";
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
  # dconf = mkIf isDesktop {
  #   enable = true;
  #   settings = {
  #     "org/gnome/shell" = {
  #       disable-user-extensions = false;
  #       enabled-extensions = with pkgs.gnomeExtensions; [
  #         appindicator.extensionUuid
  #         paperwm.extensionUuid
  #         just-perfection.extensionUuid
  #       ];
  #
  #     };
  #     "org/gnome/desktop/wm/keybindings" = {
  #       switch-to-workspace-1 = [ "<Super>1" ];
  #       switch-to-workspace-2 = [ "<Super>2" ];
  #       switch-to-workspace-3 = [ "<Super>3" ];
  #       switch-to-workspace-4 = [ "<Super>4" ];
  #       switch-to-workspace-5 = [ "<Super>5" ];
  #       switch-to-workspace-6 = [ "<Super>6" ];
  #       switch-to-workspace-7 = [ "<Super>7" ];
  #       switch-to-workspace-8 = [ "<Super>8" ];
  #       switch-to-workspace-9 = [ "<Super>9" ];
  #
  #       move-to-workspace-1 = [ "<Super><Shift>1" ];
  #       move-to-workspace-2 = [ "<Super><Shift>2" ];
  #       move-to-workspace-3 = [ "<Super><Shift>3" ];
  #       move-to-workspace-4 = [ "<Super><Shift>4" ];
  #       move-to-workspace-5 = [ "<Super><Shift>5" ];
  #       move-to-workspace-6 = [ "<Super><Shift>6" ];
  #       move-to-workspace-7 = [ "<Super><Shift>7" ];
  #       move-to-workspace-8 = [ "<Super><Shift>8" ];
  #       move-to-workspace-9 = [ "<Super><Shift>9" ];
  #
  #       close = [ "<Super>q" ];
  #     };
  #   };
  # };
  services.gpg-agent = mkIf stdenv.isLinux {
    enable = pkgs.stdenv.isLinux;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
}
