{ pkgs, ... }:
{
  services = {
    resolved.enable = false;

    kresd = {
      enable = true;
      package = pkgs.knot-resolver_5.override { extraFeatures = true; };

      listenPlain = [ "53" ];

      extraConfig = builtins.readFile ./kresd.lua;
    };
  };
  # lan is a trusted interface, isolated deliberately is not
  networking.firewall.interfaces.isolated.allowedUDPPorts = [ 53 ];
}
