{ pkgs, ... }:
let
  pythonPackages =
    p: with p; [
      aiohttp # async HTTP
      beautifulsoup4 # web scraping
      #folium # maps
      # geopy # geographical data
      ipython # interactive shell
      # jupyter # interactive notebooks
      # matplotlib # plots
      # networkx # graphs
      numpy # numerical computation
      pandas # data analysis
      pylint # static checking
      # pwntools
      requests # HTTP library
      setuptools # setup.py
      # z3 # Z3 theorem prover
    ];
in
{
  home.packages = [ (pkgs.python3.withPackages pythonPackages) ];
}
