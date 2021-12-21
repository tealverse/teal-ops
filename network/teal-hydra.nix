let
  key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEGcYkWwCqHR9WlVdp89LWgW+kzJkPtJ0DGC3JGHQZEtCeJX8CGHZr2ahHgGRFKiirbB1fUlEmqAEDFEuZiAS6Nbl7RPV9hbQoxWI1r3euI6ZDKWoF0dUljUVOEfGcuoN/eokQceBCdpFHINB4FmMKZ+qMv0tS5Cl7clm55NBP/BTDl+JBvM3SfkIdeZOttYTmSJnyeK/nlNQbDFcDTxUvkdRkLpLUj+kb4OwXQIjbKpDDZ/W1DIM9ha0JyknPWGDiI0/HSfxdIqJ9ZI+/rQlr4A52xCi0FAW/xcM/AzwsgE6t4vREMCCKXcSFcmvQBvT7rS3dZe16Cus3PDLDAM4nVVCvTyPfuR4UOTIOhbF+gXxOMonHWoqquQDU+A6fiJs7L4lXwSyGh9/36IWr7mELS8Vc0uSSAl6vGOwbC6wlVH/DouZs7VNCwktaEAzEmS/Fmjzg3geRASJkHqT4q7pqWRTg0adRTsecNppBOZpECXvqYfFWX13YeRSW+j5HAdk= teal-hydra";
in
{ config, pkgs, modulesPath, ... }:
{
  services.httpd.enable = true;
  services.httpd.adminAddr = "admin@teal.ooo";

  services.httpd.virtualHosts = {
    "hydra.teal.no-day.org" = {
      listen = [{ port = 80; }];
      documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
    };
  };

  nix.binaryCaches = [
    "https://hydra.iohk.io"
    "https://iohk.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.binaryCachePublicKeys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  nix.sshServe.enable = true;
  # nix.sshServe.write = true;
  nix.sshServe.protocol = "ssh-ng";
  nix.sshServe.keys = [ key ];
  # nix.trustedUsers = [ "nix-ssh" ];

  environment.systemPackages = [ pkgs.busybox ];

  boot.cleanTmpDir = true;
  networking.hostName = "teal-hydra";

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [ key ];

  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

  networking.firewall.allowedTCPPorts = [ 80 22 3000 ];

  deployment.targetHost = "hydra.teal.no-day.org";

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
  };
}
