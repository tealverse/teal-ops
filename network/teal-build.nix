let
  key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC68OuQnpJNHeTfLw6xOWWb60FIqklrN8oewxHEiwgBofLkHC7V3I9cuMcEqdYs5UGllXO3pc5AdDCTsBd/hCLbuhJ4NVA6HODfWZjPt9bwgPCU0cTMC03g9I6t1KmK84Nrv3QkQ6+358VBiMbRBgYPG0e9tyyA9N9UXh3OYlA81Bz/d6BJUD42NnljrlSbgDCmsLtG8Dye++f8YA+xQHvis2iUbh46m0Ku/jt4icI62gn6e6JN9+n2R3FjVF1FUpGF19iZQmbioTM5sMFMCEcADStBVc8+XgU3X5nWCfcFDxVTbo0A+ZtlroNJEVxxWJ12a3Lem2edkNtOBE+XvDTlENuReY4uhtxZQa+BNYpGjHwe7x7PMmyvHXDPczPm08d307qF8INuwLaJOtdidTIEfVBaqLa91mnkAmr3bqjqjioXEMKXQ611hu0x9Tp/S89PxttAcLyjwl9ReMsbyRU52n3TIFC00pWMKrnENQtwHTsLKGRR/yiS5RAlGt6P1OU=";
in
{ config, pkgs, modulesPath, ... }:
{
  services.httpd.enable = true;
  services.httpd.adminAddr = "admin@teal.ooo";

  services.httpd.virtualHosts = {
    "build.teal.no-day.org" = {
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

  environment.systemPackages = [ pkgs.busybox pkgs.git pkgs.nixops ];
  nix.envVars = {
    TMPDIR = "/var/tmp";
  };

  boot.cleanTmpDir = true;
  networking.hostName = "teal-build";

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [ key ];

  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

  networking.firewall.allowedTCPPorts = [ 80 22 ];

  deployment.targetHost = "build.teal.no-day.org";
}
