# Checklist for setting up a new host

1. Setup disko configuration
    - Fill in disk names by booting live image on new host
2. Create script to automate installation
    - E.g. use the initial.sh script from iqaluk
3. Enroll TPM2 for disk decryption
    - And/or enroll a physical security key for unlocking
4. Enroll secure boot
5. Enroll ssh key in authorizedkeys for all hosts
    - Generate ssh key: ssh-keygen -t ed25519 -C "user@host"
    - Add to authorizedkeys
6. Enroll host in sops with ssh-to-age for the main user
    - Generate a key
    - Ensure permissions, e.g. chmod 400 ~/.config/sops/age/keys.txt
7. Verify backups are working
8. Enroll ssh key in github
