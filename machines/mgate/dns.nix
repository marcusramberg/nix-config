{ pkgs, ... }:
{
  services = {
    resolved.enable = false;

    kresd = {
      enable = true;
      package = pkgs.knot-resolver.override { extraFeatures = true; };

      listenPlain = [ "53" ];

      extraConfig = builtins.readFile ./kresd.lua;
    };
  };
  networking.firewall.interfaces.lan.allowedUDPPorts = [ 53 ];
}
