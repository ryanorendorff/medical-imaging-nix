{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.vncservice;

in {

  options.services.vncservice.enable = mkEnableOption "vncservice";

  options.services.vncservice.port = mkOption {
    default = ":2";
    type = types.string;
    description = "Incremental port number for VNC service";
  };

  config = mkIf (cfg.enable) {
    systemd.services.vncserver = {
      enable = true;
      description = "Remote desktop service (VNC)";

      after = [ "syslog.target" "network.target" ];
      path = with pkgs; [ perl xorg.xauth xorg.xhost ];

      serviceConfig = {
        Type = "forking";
        User = "momentum";
        Group = "users";
        WorkingDirectory = "/home/momentum";
        ExecStartPre =
          "${pkgs.bash}/bin/sh -c '${pkgs.tigervnc}/bin/vncserver -kill ${config.services.vncservice.port} > /dev/null 2>&1 || :'";
        ExecStart =
          "${pkgs.tigervnc}/bin/vncserver ${config.services.vncservice.port} -geometry 1440x800";
        ExecKill =
          "${pkgs.tigervnc}/bin/vncserver -kill ${config.services.vncservice.port}";
        Restart = "on-failure";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}

