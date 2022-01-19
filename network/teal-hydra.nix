let
  key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLGg8WZuO7r2pC5Ce50DO/Eua2vH2oqPUhFntML1sP8pZOEylViiwaJsWzx/u612Mfb+n+PPwVjRrHGe8nsneQM6kYsKKm0tmMhPQytVEXatgQBxWZ+tkCaxVQ7Y7zfdUqxiWycjS3itVGGLGRDhPBGiEbsnw4KZItCJPNbdoBZG5BpibKyykPk21/spBjlzQa4HjFeDmS4R5hbM9KpO7y4VBmcoV9IlRZzY6n13dQjczlosMzwAss69XnnWjo9dDiz7VWiUHHXrrzOZIK+I+jiU1LGJ6JaMAGMgILmE3NvieWKXvgVfFp6BS45dTwOJGzYG1Ggw1XMcjRgS5KOovk/Ruj32EH3WBS9u6fzNdh69Xi90GhqivpkNWWttXVJcuaxNa6XhFcGNieWY1RJfqeTYF/xsxP+R9IxZYYll5l12+uCX/DDjk8P3pzuNK95owre+y1hMjM5ikytOk4DvK+JiRWgKp4/mMvf1VgKAameWYDKa/7o5Jrj4NECLv53o8= teal-hydra";
in
{ config, pkgs, modulesPath, ... }:
{
  services.httpd.enable = true;
  services.httpd.adminAddr = "admin@teal.ooo";

  services.httpd.virtualHosts = {
    "hydra.teal.ooo" = {
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

  deployment.targetHost = "hydra.teal.ooo";

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
  };
}
