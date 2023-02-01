{ pkgs, lib, config, ... }:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    serverProperties = {
      server-port = 43000;
      difficulty = 1;
      gamemode = 0;
      max-players = 10;
      motd = "minecraft.means.no";
      white-list = false;
      enable-rcon = true;
      "rcon.password" = "omgP0nies";
      force-gamemode = true;
      seed = "-613756530319979507";
      online-mode = "false";
    };
    package = let 
     version = "19w45b";
        url = "https://launcher.mojang.com/v1/objects/1b557e7b033b583cd9f66746b7a9ab1ec1673ced/server.jar";
        sha256 = "58f329c7d2696526f948470aa6fd0b45545039b64cb75015e64c12194b373da6";
    in (pkgs.minecraft-server.overrideAttrs (old: rec {
      name = "minecraft-server-${version}";
      inherit version;

      src = pkgs.fetchurl {
        inherit url sha256;
      };
    }));

   # https://launcher.mojang.com/v1/objects/0d0d7db69eb40408c23ce4503dfd00671bcb9e6b/server.jar
  };
}
