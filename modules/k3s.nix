{ _ }:

{
  services.k3s = {
    enable = true;
    token = "rxjf4Z2m3tdj5";
    extraFlags = "--server https://192.168.86.200:6443";
  };
}
