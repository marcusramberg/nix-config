{ pkgs, ... }:
{
  programs = {
    eza = {
      enable = true;
      enableFishIntegration = true;
      icons = "auto";
      git = true;
    };
    bottom.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
    helix = {
      enable = true;
    };
    home-manager.enable = true;
    htop = {
      enable = true;
      settings.show_program_path = true;
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
    rbw = {
      enable = true;
      settings = {
        base_url = "https://passwords.means.no/";
        email = "marcus@means.no";
        pinentry = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry;
      };
    };
    ssh = {
      enable = true;
      controlMaster = "auto";
    };
    # Smarter z
    zoxide.enable = true;
  };
}
