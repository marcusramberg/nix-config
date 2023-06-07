_: {

  services.lemmy = {
    enable = true;
    settings = {
      database = { url = "postgres://lemmy:lemmy@localhost:5432/lemmy"; };

      hostname = "posta.no";
      captcha.enabled = true;
      federation.enabled = true;
      database = { host = "localhost"; };
    };
    database = { createLocally = true; };
  };
}

