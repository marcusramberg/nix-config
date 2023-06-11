{ config, ... }: {
  config.services.postfix = {
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
  config.virtualisation = {
    podman.enable = true;
    oci-containers = {
      containers.lemmy-server = {
        image = "dessalines/lemmy:0.17.3";
        # ports = [ "8536:8536" ];
        extraOptions = [ "--network=host" ];
        environment = {
          RUST_LOG =
            "warn,lemmy_server=warn,lemmy_api=info,lemmy_api_common=info,lemmy_api_crud=info,lemmy_apub=info,lemmy_db_schema=info,lemmy_db_views=info,lemmy_db_views_actor=info,lemmy_db_views_moderator=info,lemmy_routes=info,lemmy_utils=info,lemmy_websocket=info";
          RUST_BACKTRACE = "full";
        };
        volumes = [ "/var/lib/lemmy/lemmy.hjson:/config/config.hjson" ];
      };
      containers.pictrs = {
        image = "asonix/pictrs:0.3.1";
        environmentFiles = [ config.age.secrets.picserver.path ];
        ports = [ "4585:8080" ];
        volumes = [ "/space/pictrs:/mnt" ];
      };

      containers.lemmy-ui = {
        image = "dessalines/lemmy-ui:0.17.3";
        extraOptions = [ "--network=host" ];
        # ports = [ "1236:1236" ];
        environment = {
          LEMMY_UI_LEMMY_INTERNAL_HOST = "localhost:8536";
          LEMMY_UI_LEMMY_EXTERNAL_HOST = "posta.no:1236";
          LEMMY_HTTPS = "true";
        };
      };
    };
  };
}

