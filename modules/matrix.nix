{ config, ... }: {
  config.services.matrix-conduit = {
    enable = true;
    settings.global = {
      server_name = "means.no";
      address = "0.0.0.0";
    };
  };
}
