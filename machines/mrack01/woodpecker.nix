{ config, ... }:
{
  age.secrets.woodpecker-ci.owner = "woodpecker-server";
  services.woodpecker-server = {
    enable = true;
    environment = {
      WOODPECKER_HOST = "https://ci.bas.es";
      WOODPECKER_OPEN = "true";
      WOODPECKER_ORGS = "bas.es";
      WOODPECKER_ADMIN = "marcus";
      WOODPECKER_FORGEJO = "true";
      WOODPECKER_FORGEJO_URL = "https://code.bas.es";
      WOODPECKER_FORGEJO_CLIENT = "a2bb5dd4-85db-4d83-a7bc-12166b7aa5b7";
    };
    environmentFile = config.age.secrets.woodpecker-ci.path;
  };
}
