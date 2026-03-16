# Taken from https://github.com/NixOS/nixpkgs/issues/271442#issuecomment-2740328077
# Title: squeezelite service cannot connect to Pulseaudio
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    optionalString
    types
    ;

  dataDir = "/var/lib/squeezelite";
  runtimeDir = "/run/squeezelite";

  cfg = config.services.squeezelite-271442;
  pkg = pkgs.squeezelite-pulse;
  bin = "${pkg}/bin/${pkg.pname}";
in
{

  ###### interface

  options.services.squeezelite-271442 = {
    enable = mkEnableOption "Squeezelite, a software Squeezebox emulator";

    extraArguments = mkOption {
      default = "";
      type = types.str;
      description = ''
        Additional command line arguments to pass to Squeezelite.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          (
              config.services.pipewire.enable
              && config.services.pipewire.pulse.enable
              && config.services.pipewire.systemWide
          );
        message = ''
                    `services.squeezelite.pulseAudio = true' requires a system-wide Pulseaudio server.
                    - `services.pipewire.enable = true', `services.pipewire.pulse.enable = true', and `services.pipewire.systemWide = true'
          should be set.
        '';
      }
    ];

    systemd.user.services.squeezelite = {
      enable = true;
      wantedBy = [ "default.target" ];
      after = [ "network.target" "pipewire.service" "pipewire-pulse.socket" ];
      requires = [ "network.target" "pipewire.service" "pipewire-pulse.socket" ];
      description = "Software Squeezebox emulator";
      serviceConfig = {
        ExecStart = "${bin} -N ${dataDir}/player-name ${cfg.extraArguments}";
        StateDirectory = builtins.baseNameOf dataDir;
        RuntimeDirectory = builtins.baseNameOf runtimeDir;
        SupplementaryGroups = "audio pipewire";
      };
    };
  };
}
