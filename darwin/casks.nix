_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    casks = [
      "alfred"
      "alt-tab"
      "android-platform-tools"
      "androidtool"
      "arc"
      "balenaetcher"
      "barrier"
      "basictex"
      "burp-suite"
      "calibre"
      "cloudflare-warp"
      "cyberduck"
      #      "dash"
      "diffusionbee"
      "discord"
      "dolphin"
      "element"
      "floorp"
      "freecad"
      "gitify"
      "google-chrome"
      "google-drive"
      "hammerspoon"
      "inkscape"
      "iterm2"
      "karabiner-elements"
      "lens"
      "macfuse"
      "microsoft-remote-desktop"
      "morpheus"
      "netnewswire"
      "nordpass"
      "notion-enhanced"
      "obs"
      #      "obs-ndi"
      "obs-websocket"
      "obsidian"
      "parallels"
      "pgadmin4"
      "plex"
      "plexamp"
      "pocket-casts"
      "prusaslicer"
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "quicklook-csv"
      "quicklook-json"
      "raycast"
      "sf-symbols"
      "signal"
      "slack"
      "soulseek"
      "soulver"
      "steam"
      "synology-drive"
      "telegram"
      "the-unarchiver"
      "ultimaker-cura"
      "visual-studio-code"
      "vivaldi"
      "vlc"
      "wezterm@nightly"
      "xcodes"
      "yt-music"
      "yubico-yubikey-manager"
    ];
    masApps = {
      "Bitwarden" = 1352778147;
      "ReadKit" = 1615798039;
      "UTM Virtual Machines" = 1538878817;
    };
    taps = [ "homebrew/cask-versions" ];
  };
}
