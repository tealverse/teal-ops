{
  network.description = "Web server";

  webserver =
    { config, pkgs, ... }:
    { services.httpd.enable = true;
      services.httpd.adminAddr = "admin@teal.ooo";
      services.httpd.documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
      networking.firewall.allowedTCPPorts = [ 80 ];
      deployment.targetHost = "65.108.150.252";
    };
}