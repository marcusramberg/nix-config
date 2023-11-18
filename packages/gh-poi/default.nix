{ fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gh-poi";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "seachicken";
    repo = "gh-poi";
    rev = "v${version}";
    sha256 = "sha256-7KZSZsYfo9zZ0HSg5yLDNTlwb30byD73kqMNHc0tQpo=";
  };

  vendorHash = "sha256-D/YZLwwGJWCekq9mpfCECzJyJ/xSlg7fC6leJh+e8i0=";

  checkPhase = ""; # tests fail due to not being in Git repo?

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];
}
