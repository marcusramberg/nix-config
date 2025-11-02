{ pkgs, ... }:
{
  services.forgejo = {
    package = pkgs.forgejo;
    database = {
      type = "postgres";
      socket = "/run/postgresql";
    };
    dump = {
      enable = true;
      backupDir = "/backup/forgejo";
    };
    enable = true;
    lfs.enable = true;
    settings = {
      actions.ENABLED = false;
      openid = {
        ACCOUNT_LINKING = "auto";
        USERNAME = "nickname";
        OPENID_CONNECT_SCOPES = "email profile";
        ENABLE_OPENID_SIGNIN = true;
        ENABLE_OPENID_SIGNUP = true;
        WHITELISTED_URIS = "https://auth.means.no,https://auth.bas.es";
      };
      repository = {
        ENABLE_PUSH_CREATE_ORG = true;
        ENABLE_PUSH_CREATE_USER = true;
      };
      session.COOKIE_SECURE = true;
      server = {
        ROOT_URL = "https://code.bas.es";
        PROTOCOL = "http+unix";
      };
      service = {
        # DISABLE_REGISTRATION = mkForce false;
        # ALLOW_ONLY_EXTERNAL_REGISTRATION = false;
        SHOW_REGISTRATION_BUTTON = false;
        AUTO_WATCH_NEW_REPOS = false;
      };
      ui = {
        THEMES = "bas-es, forgejo-auto, forgejo-light, forgejo-dark, gitea-auto, gitea-light, gitea-dark, forgejo-auto-deuteranopia-protanopia, forgejo-light-deuteranopia-protanopia, forgejo-dark-deuteranopia-protanopia, forgejo-auto-tritanopia, forgejo-light-tritanopia, forgejo-dark-tritanopia";
        DEFAULT_THEME = "bas-es";
      };
    };
  };
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = false;
    ensureDatabases = [ "forgejo" ];
    ensureUsers = [
      {
        name = "forgejo";
        ensureDBOwnership = true;
      }
    ];
  };
}
