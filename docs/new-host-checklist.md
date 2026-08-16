# Checklist for setting up a new host

- Setup disko configuration
    - Fill in disk names by booting live image on new host
- Create script to automate installation
    - E.g. use the initial.sh script from iqaluk
- Setup keepass for password management
    - Setup syncing of password file
- Enroll TPM2 for disk decryption
    - And/or enroll a physical security key for unlocking
- Enroll secure boot
- Enroll ssh key in authorizedkeys for all hosts
    - Generate ssh key: ssh-keygen -t ed25519 -C "user@host"
    - Add to authorizedkeys
- Enroll host in sops with ssh-to-age for the main user
    - Generate a key
    - Ensure permissions, e.g. chmod 400 ~/.config/sops/age/keys.txt
- Verify backups are working
- Enroll ssh key in github
