# Adds the Cloudflare DNS validation module

_: _final: prev:

let

  plugins = [ "github.com/caddy-dns/cloudflare" ];
  goImports =
    prev.lib.flip prev.lib.concatMapStrings plugins (pkg: "   _ \"${pkg}\"\n");
  goGets = prev.lib.flip prev.lib.concatMapStrings plugins
    (pkg: "go get ${pkg}\n      ");
  main = ''
    package main
    import (
    	caddycmd "github.com/caddyserver/caddy/v2/cmd"
    	_ "github.com/caddyserver/caddy/v2/modules/standard"
    ${goImports}
    )
    func main() {
    	caddycmd.Main()
    }
  '';

in {
  caddy-cloudflare = prev.buildGo120Module {
    pname = "caddy-cloudflare";
    inherit (prev.caddy) version;
    runVend = true;

    subPackages = [ "cmd/caddy" ];

    inherit (prev.caddy) src;

    vendorHash = "sha256-n8RKWOb15BN5ZTpZEM1m3+wg8GGtHiN/FQXbxBp4Tp8=";

    overrideModAttrs = _: {
      preBuild = ''
        echo '${main}' > cmd/caddy/main.go
        ${goGets}
      '';
      postInstall = "cp go.sum go.mod $out/ && ls $out/";
    };

    postPatch = ''
      echo '${main}' > cmd/caddy/main.go
      cat cmd/caddy/main.go
    '';

    postConfigure = ''
      cp vendor/go.sum ./
      cp vendor/go.mod ./
    '';

    meta = with prev.lib; {
      homepage = "https://caddyserver.com";
      description =
        "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
      license = licenses.asl20;
      maintainers = with maintainers; [ Br1ght0ne techknowlogick ];
    };
  };
}
