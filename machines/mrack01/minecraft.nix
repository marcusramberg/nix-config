{ pkgs, ... }:
{
  networking.firewall = {
    allowedUDPPorts = [
      19132
    ];
  };
  services.minecraft-server = {
    enable = true;
    eula = true;
    jvmOpts = "-Xms10000M -Xmx24000M";
    openFirewall = true;
    package = pkgs.papermcServers.papermc;
    # whitelist = {
    #   mramberg = "d2be212b-ac47-4f8f-b7be-2ae551a41102";
    # };
    # serverProperties = {
    #   motd = "NixOS Minecraft Server";
    #   gamemode = "survival";
    #   difficulty = "normal";
    #   view-distance = 32;
    #   use-native-transport = true;
    # };
    # operators = {
    #   mramberg = "d2be212b-ac47-4f8f-b7be-2ae551a41102";
    # };
  };
}
