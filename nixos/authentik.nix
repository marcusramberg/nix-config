{ config, ... }:
{
  services.authentik = {
    enable = true;
    environmentFile = config.age.secrets.authentik.path;
    settings = {
      email = {
        host = "smtp.mail.me.com";
        port = 587;
        username = "marcusramberg@icloud.com";
        use_tls = true;
        use_ssl = false;
        from = "marcus@means.no";
      };
      disable_startup_analytics = true;
      avatars = "initials";
    };
  };
  authentik-ldap = {
    enable = true;
  };
}
