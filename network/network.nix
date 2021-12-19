{
  network.description = "Build network";

  "teal-build" =
    { config, pkgs, modulesPath, ... }:
    {
      services.httpd.enable = true;
      services.httpd.adminAddr = "admin@teal.ooo";

      services.httpd.virtualHosts = {
        "65.21.251.123" = {
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
      nix.sshServe.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2iqS0q4FXoN6ugI5CjCbBkg0v0ZmKiAsf4sofqZDe2uJIFD6aPoEunxaerhGQf63wGJMXD256XUSwpINssE5JqslrWC2ED28zEATQA5wKE41Qif5nLQzIJ8Gxb2BZ1MNieaD3Zwj56kqf5Bj4kJLrDMG4+sB+yTsQnhnt68G9wkPErsl7RhW3bMfnC1UetE5OpvWJ21k4UxtBsYM5WdAUOxVKmbPOrCYVtrC8tntyrXCxKLBOBLXIlyrWA2p09MEu4+3z0t7KwHdlygsXwhe+TMDq1Te+Xs5yAOqxBwbxzVid6n3IxUxP28bpE6wpNOiR3TBs3heGs7b6BeZGqe/hKXa8FaNUDvKUj5UQEoiJ4VgpsuL4XJLnLvvDSNWg6vSEAgOa7veXcOxa++sF/aoAAQfoy1b30RVVsrdTRvN5Qbp+jRGk+Yahr3saWYKSZ6wvFn0u5mMeRW5MWyLk/rqB/pFmVB4RLoWLSx0G7fELBGlmjpRcZJjTYq25/PSLSLE= teal-build" ];
      # nix.trustedUsers = [ "nix-ssh" ];

      environment.systemPackages = [ pkgs.busybox pkgs.git pkgs.nixops ];

      boot.cleanTmpDir = true;
      networking.hostName = "teal-build";

      services.openssh.enable = true;

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2iqS0q4FXoN6ugI5CjCbBkg0v0ZmKiAsf4sofqZDe2uJIFD6aPoEunxaerhGQf63wGJMXD256XUSwpINssE5JqslrWC2ED28zEATQA5wKE41Qif5nLQzIJ8Gxb2BZ1MNieaD3Zwj56kqf5Bj4kJLrDMG4+sB+yTsQnhnt68G9wkPErsl7RhW3bMfnC1UetE5OpvWJ21k4UxtBsYM5WdAUOxVKmbPOrCYVtrC8tntyrXCxKLBOBLXIlyrWA2p09MEu4+3z0t7KwHdlygsXwhe+TMDq1Te+Xs5yAOqxBwbxzVid6n3IxUxP28bpE6wpNOiR3TBs3heGs7b6BeZGqe/hKXa8FaNUDvKUj5UQEoiJ4VgpsuL4XJLnLvvDSNWg6vSEAgOa7veXcOxa++sF/aoAAQfoy1b30RVVsrdTRvN5Qbp+jRGk+Yahr3saWYKSZ6wvFn0u5mMeRW5MWyLk/rqB/pFmVB4RLoWLSx0G7fELBGlmjpRcZJjTYq25/PSLSLE= teal-build"
      ];

      imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
      boot.loader.grub.device = "/dev/sda";
      boot.initrd.kernelModules = [ "nvme" ];
      fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

      networking.firewall.allowedTCPPorts = [ 80 22 ];

      deployment.targetHost = "65.21.251.123";
    };
}


