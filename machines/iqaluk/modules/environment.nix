{
  pkgs,
  ...
}:

{
  time.timeZone = "Europe/Amsterdam";

  environment.variables.EDITOR = "vim";

  programs.bash.completion.enable = true;

  environment.systemPackages = with pkgs; [
    # rust cli tools
    eza # ls
    bat # cat
    ripgrep # grep
    fzf # fuzzy find
    pv # pipe viewer

    pciutils
    wget
    vim
    firefox
    gitFull
    mergiraf
    htop
    tree
    sl
    vlc
    syncthing
    fping
    vscodium
    jq
    libreoffice
    file
    zip
    screen
    p7zip
    fdupes
    mqttui # handy for mqtt debugging/logging
    mqttx
    minicom # for uart / serial debugging
    qalculate-qt # calculator gui application

    gnome-decoder # handy to share small textual data with a phone

    # pdf viewer
    kdePackages.okular

    # photo viewer
    nomacs

    # communication
    element-desktop
    irssi
    thunderbird

    rtl_433

    # frequently used dev tools
    diffoscopeMinimal
    qemu
    valgrind
    nixpkgs-review
    nix-output-monitor
    treefmt

    # remote desktop
    remmina

    # https://github.com/NixOS/nixpkgs/issues/66093
    adwaita-icon-theme

    android-tools
    chromium

    nixfmt
    nixd

    # samba
    cifs-utils
    samba4

    usbutils
    ntfs3g
    parted

    # DLNA
    minidlna
    ums # universal media server
    jellyfin
    jellyfin-ffmpeg
    jellyfin-web

    # Communication to smart meter
    socat
    #ser2net

    # Hard disk monitoring
    smartmontools
    gsmartcontrol

    # Scanner
    simple-scan
    kdePackages.skanlite

    # secret management
    age
    age-plugin-yubikey
    keepassxc
    sops
    ssh-to-age

    # script to sync changed data to SSD from parents
    (writeShellScriptBin "sync-photos-to-ssd" ''
      set -euxo pipefail
      export PATH="${
        lib.makeBinPath ([
          pkgs.rsync
          # Below packages should definitely be in ambient environment.
          #pkgs.samba4
          #pkgs.cifs-utils
        ])
      }:$PATH"
      # TODO(Mindavi): Maybe show list first and ask for confirmation?
      sudo mkdir -p /mnt/copydrive
      sudo mount -t cifs //fd37:191a:d082:555::1/copydrive /mnt/copydrive/ -o rw -o vers=3 -o credentials=~/.smbcredentials
      rsync --modify-window=2 --size-only /mnt/copydrive/Fotos/ /run/media/rick/Familie\ van\ Schijndel/Fotos/ -v --recursive --itemize-changes --info=progress2
      sudo umount /mnt/copydrive && sync && sudo rm -r /mnt/copydrive
    '')
  ];
}
