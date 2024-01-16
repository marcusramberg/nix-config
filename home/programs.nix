{ pkgs, ... }: {
  programs = {
    eza = {
      enable = true;
      enableAliases = true;
      icons = true;
      git = true;
    };
    bottom.enable = true;
    git.difftastic = {
      background = "dark";
      display = "inline";
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
    helix = { enable = true; };
    home-manager.enable = true;
    htop = {
      enable = true;
      settings.show_program_path = true;
    };
    i3status-rust = {
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
              format = " $icon $timestamp.datetime(f:'%a %F %R') ";
            }
          ];
        };
      };
    };
    keychain.enable = true;
    # navi.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    neovim = {
      extraConfig = ":luafile ~/.config/nvim/init.lua";
      viAlias = true;
      vimAlias = true;
    };
    gh = {
      enable = true;
      extensions = [ pkgs.gh-dash pkgs.gh-poi pkgs.gh-tidy ];
      settings = {
        git_protocol = "ssh";
        # What editor gh should run when creating issues, pull requests, etc. If
        # blank, will refer to environment.
        editor =
          ""; # When to interactively prompt. This is a global config that cannt be

        # overridden by hostname. Supported values: enabled, disabled
        prompt = "enabled";
        # A pager program to send command output to, e.g. "
        pager = ""; # Aliases allow you to create nicknames for gh commands

        aliases = {
          co = "pr checkout";
          rev = "pr review";
          mkpr = "pr create --fill";
          # The path to a unix socket through which send HTTP connections. If
          # blank, HTTP traffic will be handled by net/http.DefaultTransport.
        };
        http_unix_socket = "";
        browser = "";
        version = 1;
      };
    };
    # Smarter z
    zoxide.enable = true;
  };
}

