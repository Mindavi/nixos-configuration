# Secure boot setup on iqaluk

This is a short manual explaining how to setup secure boot on the machine.

1. Follow lanzaboote manual: https://nix-community.github.io/lanzaboote/getting-started/prepare-your-system.html
2. For the Enable Secure Boot step
    a. Press esc to go into Setup (UEFI configuration)
    b. Enable secure boot with 'Custom' mode
    c. Press "Reset to Setup Mode" and press OK on the warning
    d. Go to "Expert Key Management" and set "Factory Key Provision" to [Disabled]
        - Otherwise somehow the setup mode will automatically enroll factory keys and not boot NixOS
3. Follow the manual further (Enroll Keys) with `sudo sbctl enroll-keys`
    - Seems like enrolling the microsoft keys is not required for the machine
4. Reboot
