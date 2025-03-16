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
      "barrier"
      "basictex"
      "calibre"
      "cloudflare-warp"
      "cyberduck"
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
      "macfuse"
      "microsoft-remote-desktop"
      "morpheus"
      "netnewswire"
      "nordpass"
      "obs"
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
      "sf-symbols"
      "signal"
      "slack"
      "soulseek"
      "soulver"
      "steam"
      "synology-drive"
      "telegram"
      "the-unarchiver"
      "visual-studio-code"
      "vivaldi"
      "vlc"
      "wezterm@nightly"
      "xquartz"
      "xcodes"
      "yt-music"
      "yubico-yubikey-manager"
    ];
    masApps = {
      "Bitwarden" = 1352778147;
      "ReadKit" = 1615798039;
      "UTM Virtual Machines" = 1538878817;
    };
  };
}
