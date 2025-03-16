{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.profiles.authelia;
in
{
  age.secrets = {
    authelia-jwt.owner = "authelia-auth";
    authelia-storage-enc.owner = "authelia-auth";
  };

  options.profiles.authelia = {
    enable = mkEnableOption "authelia authentication service";
    auth_host = mkOption {
      type = types.path;
      description = "Authentication hostname";
      default = "auth.means.no";
    };

  };

  config = mkIf cfg.enable {
    services.authelia.instances.auth = {
      enable = true;
      secrets = {
        jwtSecretsFile = config.age.secrets.authelia-jwt.path;
        storageEncryptionKeyFile = config.age.secrets.authelia-storage-enc.path;
      };
      settings = {
        theme = "dark";
        default_2fa_method = "totp";
        default_redirection_url = "https://passport.${cfg.auth_host}/";
        authentication_backend = {
          file.path = "/var/lib/authelia-auth/user.yml";
        };
        session = {
          domain = pqdn;
          expiration = 3600;
          inactivity = 300;
        };
        totp = {
          issuer = "means.no";
          disable = false;
          algorithm = "sha1";
          digits = 6;
          period = 30;
          skew = 1;
          secret_size = 32;
        };
        server = {
          host = "0.0.0.0";
          port = 9091;
        };
      };
      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = pqdn;
            policy = "bypass";
          }
        ];
      };
      storage = {
        local = {
          path = "/var/lib/authelia-auth/sqlite.db";
        };
      };
    };
  };
}
