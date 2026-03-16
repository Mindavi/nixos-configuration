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
  pkg = if cfg.pulseAudio then pkgs.squeezelite-pulse else pkgs.squeezelite;
  bin = "${pkg}/bin/${pkg.pname}";
  grp =
    if cfg.pulseAudio then
      (if config.services.pulseaudio.systemWide then "pulse-access" else "pipewire")
    else
      "audio";
  deps =
    if cfg.pulseAudio then
      (
        if config.services.pulseaudio.systemWide then
          [ "pulseaudio.service" ]
        else
          [
            "pipewire.service"
            "pipewire-pulse.socket"
          ]
      )
    else
      [ "sound.target" ];

in
{

  ###### interface

  options.services.squeezelite-271442 = {
    enable = mkEnableOption "Squeezelite, a software Squeezebox emulator";

    pulseAudio = mkEnableOption "pulseaudio support";

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
          !cfg.pulseAudio
          || (
            (config.services.pulseaudio.enable && config.services.pulseaudio.systemWide)
            || (
              config.services.pipewire.enable
              && config.services.pipewire.pulse.enable
              && config.services.pipewire.systemWide
            )
          );
        message = ''
                    `services.squeezelite.pulseAudio = true' requires a system-wide Pulseaudio server. Either:
                    - `services.pulseaudio.enable = true' and `services.pulseaudio.systemWide = true'
                    or
                    - `services.pipewire.enable = true', `services.pipewire.pulse.enable = true', and `services.pipewire.systemWide = true'
          should be set.
        '';
      }
    ];

    systemd.services.squeezelite = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ deps;
      requires = [ "network.target" ] ++ deps;
      description = "Software Squeezebox emulator";
      serviceConfig = {
        Environment = "XDG_CONFIG_HOME=${dataDir} XDG_RUNTIME_DIR=${runtimeDir}";
        DynamicUser = true;
        ExecStart = "${bin} -N ${dataDir}/player-name ${cfg.extraArguments}";
        StateDirectory = builtins.baseNameOf dataDir;
        RuntimeDirectory = builtins.baseNameOf runtimeDir;
        # TODO(Mindavi): SupplementaryGroups?
        Group = grp;
      };
    };
  };
}
