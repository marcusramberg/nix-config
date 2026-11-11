{
  config,
  lib,
  ...
}:

let
  cfg = config.profiles.gradientWorker;
  peers = config.age.secrets."gradient-${config.networking.hostName}";
in
{

  options.profiles.gradientWorker = {
    enable = lib.mkEnableOption "Gradient Worker";
    id = lib.mkOption {
      type = lib.types.str;
      default = "74b75b60-410e-498d-b72e-5cf99e64e6f0";
      description = "Gradient Worker ID";
    };

  };
  config = lib.mkIf cfg.enable {
    services.gradient.worker = {
      enable = true;
      inherit (cfg) id;
      serverUrl = "wss://gradient.bas.es/proto";
      peersFile = peers.path;
    };
  };
}
