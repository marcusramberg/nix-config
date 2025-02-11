{ config, lib, ... }:
with lib;
let
  cfg = config.profiles.lemmy-server;
in
{
  options.profiles.lemmy-server.enable = mkEnableOption "Enable lemmy server";

  config = mkIf cfg.enable {

    profiles.dockerHost.enable = true;
    services.postfix = {
      enable = true;
      relayHost = "smtp.sendgrid.com";
      extraConfig = ''
        smtp_sasl_auth_enable = yes
        smtp_sasl_password_maps = hash:/var/lib/lemmy/sasl_passwd
        smtp_sasl_security_options = noanonymous
        smtp_sasl_tls_security_options = noanonymous
        smtp_tls_security_level = encrypt
        header_size_limit = 4096000
        relayhost = [smtp.sendgrid.net]:587
      '';
    };
    # config.environment.etc."lemmy/lemmy.hjson".source =
    #   templateFile "lemmy_hjson" ../config/lemmy.hjson {
    #     file = config.age.secrets.lemmy.path;
    #   };
    virtualisation = {
      oci-containers.containers = {
        lemmy-server = {
          # ports = [ "8536:8536" ];
          image = "dessalines/lemmy:0.19.6";
          extraOptions = [ "--network=host" ];
          environment = {
            RUST_LOG = "warn";
            #   "warn,lemmy_server=warn,lemmy_api=info,lemmy_api_common=info,lemmy_api_crud=info,lemmy_apub=info,lemmy_db_schema=info,lemmy_db_views=info,lemmy_db_views_actor=info,lemmy_db_views_moderator=info,lemmy_routes=info,lemmy_utils=info,lemmy_websocket=info";
            # RUST_BACKTRACE = "full";
          };
          volumes = [
            "/var/lib/lemmy/lemmy.hjson:/config/config.hjson"
            "/run/postgresql:/run/postgresql"
          ];
        };
        pictrs = {
          image = "asonix/pictrs:0.5.16";
          environmentFiles = [ config.age.secrets.picserver.path ];
          ports = [ "4585:8080" ];
          volumes = [ "/space/pictrs:/mnt" ];
        };
        lemmy-ui = {
          image = "dessalines/lemmy-ui:0.19.9";
          extraOptions = [ "--network=host" ];
          # ports = [ "1236:1236" ];
          environment = {
            LEMMY_UI_LEMMY_INTERNAL_HOST = "localhost:8536";
            LEMMY_UI_LEMMY_EXTERNAL_HOST = "posta.no";
            LEMMY_HTTPS = "true";
          };
        };
      };
    };
  };
}
