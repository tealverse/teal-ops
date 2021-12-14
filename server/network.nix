let
  teal = import (builtins.fetchGit {
    url = "git@github.com:tealverse/teal.git";
    ref = "main";
  });
in
{
  network.description = "Web server";

  webserver =
    { config, pkgs, modulesPath, ... }:
    {
      services.httpd.enable = true;
      services.httpd.adminAddr = "admin@teal.ooo";

      services.httpd.virtualHosts = {
        "nix.teal.ooo" = {
          listen = [{ port = 80; }];
          documentRoot = teal.entries;
        };
      };

      environment.systemPackages = [ pkgs.busybox ];

      boot.cleanTmpDir = true;
      networking.hostName = "nix-teal";

      services.openssh.enable = true;

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDU3B+XTjn4zNzurQTU6A1arranEYprwl2jsJWWZfUMhNV5JMclYqSZhNonagsZkunElG+PBwvEkVdCHVs4FYHxH1jq7hMz+b7MyGjqF214FPVWTMe4sbBNU9qWH1TbLlJgrZCcr4of5JBomRnjJuGl5fcpQrTaJEBcRgCBbFpSP3e8EAD40lkKznB30tZkSb1jZMZokFZX5Ejc94ifOApfxPWKitzEVxTl2/fcbFllAPc5I/ZH58/i3nnRjjpsvBt5c1chyrYgF36hSOnRwwmyMn7q/KdmrRgfIdKbLFPPp82AF1DeZ+Ol5c5IsKZQsZ72ZnkEYRkaUxybEBjHwljp3FkkXho7uhs1q6xG+hUKp1G5hr5ABuFjWYGRVz53pPd/o6m5KKQn+m1oxoF3s2oCQdJJH8OXLpr46bzCybQ1w3OWrguhestjlf0gEUdBdwAY6bwW/T9C34twpLngcRTz6J0okUdOmH1JipR1rOYC8HtV/tn9E6GSuYQt0AGgTt0= nix-teal"
      ];

      imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
      boot.loader.grub.device = "/dev/sda";
      boot.initrd.kernelModules = [ "nvme" ];
      fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

      networking.firewall.allowedTCPPorts = [ 80 22 ];

      deployment.targetHost = "nix.teal.ooo";
    };
}


