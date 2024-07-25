# Backup solutions

I'd like a backup solution to ensure files, documents and pictures, databases etc are backed up.

## Requirements

### Must

- Data must be encrypted at rest at the backup provider (and I should have the key, not them).
- Must be possible to do this on a server, with a CLI tool of some sort
- Must be possible to automatically do this, some report should be given
- Has proven itself by being available for some time (without major issues?)
- Maintained (so protocol will be kept up to date, and issues resolved)
- Declarative config possible via nixos

### Should

- Compression
- Cheap / multiple storage solutions supported
- Reliable
- Easy to also backup to harddrive via a similar method
  - Of course, this could be done in a different way, but having the same method reduces the chance for errors
  - At least should use one configuration (which could be generated from a list of files or directories or so)
- Data integrity checking
- Notifications when backups are executed / done / have failed

## Tools I know / have heard of

- borg backup
- restic
- rclone
- rsync
  - No encryption by default

## Storage provider(s) I know / have heard of

- Backblaze B2
- rsync.net
- Amazon S3 (relatively expensive?)
- Dropbox (probably not really great with CLI tools?)

## Available as service for nixos

- duplicity
- duplicati
- borgbackup
  - support seems good for nixos
- restic
  - support seems good for nixos
- rsnapshot
- tarsnap
- znapzend (ZFS-specific)
- tsm-backup (IBM)
- btrbk (btrfs backup tool)
- borgmatic (powered by borg backup, notification support via ntfy)
- bacula

- postgresqlBackup -> dumps backups for postgresql databases, handy for nixos

## Available as separate tool for nixos

- deja-dup
- bup

## Tools to consider

List of tools to consider and their pros/cons.

### duplicity

Pros:

- Supports a lot of protocols, e.g.
  - S3/R2
  - DropBox
  - ftp
  - Google Drive
  - local filesystem (handy for backups to hard drive)
  - rclone
  - rsync
  - ssh/scp
- Already available since at least 2019 (rel.0.8.00, 2019-05-29)
  - Latest release 3.0 (2024-05-30), latest version in nixpkgs 2.2.3 (2024-03-20)

Cons:

- Not very well maintained in nixpkgs: https://github.com/NixOS/nixpkgs/pull/299405
  - Updates from 0.8.23 -> 2.2.3, seemingly unmaintained for a long time
  - That update is the only one, 2.2.4 was already not done and 3.0.0 neither (yet)

### borgbackup

Links:

- https://www.borgbackup.org/
- https://www.linuxlinks.com/Borg/

Pros:

- Mentioned in https://discourse.nixos.org/t/backup-solution-deja-dup-is-not-reliable/45593 by actual users
- Backups can be mounted (with FUSE)
- Encryption with AES-256
- Block size depduplication
- Data integrity verification

Cons:

- No Windows support (at least, on the website only Linux, macOS and BSD are mentioned)
- Website (frontpage) very minimal
- Version 1.0 / 1.1? Seems they barely consider it stable?

### restic

Links:

- https://restic.net/
- https://www.linuxlinks.com/restic-fast-efficient-secure-backup-software/

Pros:

- Mentioned in https://discourse.nixos.org/t/backup-solution-deja-dup-is-not-reliable/45593 by actual users
- Supports encryption with AES-256
- Deduplication
- Cross-platform support (if I ever want to add backups for windows too), Windows too
- 'Easily verify that all data can be restored'?
- Maintained in nixpkgs, multiple people try to update and r-ryantm also does
  - https://github.com/NixOS/nixpkgs/pull/323910
  - https://github.com/NixOS/nixpkgs/pull/281241
- Seems to be mentioned in different places and was stuck in my head from having researched it before

Cons:

- Version 0.16.5? Seems like they consider it unstable?

## rclone

Pros:

- Maintained in nixpkgs?

## Topics on discourse / links

- deja-dup issues: https://discourse.nixos.org/t/backup-solution-deja-dup-is-not-reliable/45593
- restic + rclone: https://discourse.nixos.org/t/trying-to-get-backups-working-with-a-webdav-remote-using-restic-rclone/26246
  - issue with solution: https://github.com/NixOS/nixpkgs/issues/220869
- https://discourse.nixos.org/t/how-do-you-backup-personal-servers/29280
  - Recommendations for both borgbackup and restic
- https://discourse.nixos.org/t/restic-backups-on-b2-with-nixos-agenix/36196
  - https://www.arthurkoziel.com/restic-backups-b2-nixos/
- what to backup: https://discourse.nixos.org/t/nixos-server-what-to-backup/25547/6
  - erase your darlings kind of config: https://github.com/tejing1/nixos-config/blob/72f70b9d2f68abca2dde606fbe20ffc402774fbc/nixosConfigurations/tejingdesk/optin-state.nix

## Providers to consider

- Backblaze R2
- BorgBase (helps paying for Borg development): https://www.borgbase.com/
- rsync.net

## Secret management tools

To manage the secrets for connecting to the backup service, some secret management must be done.
It seems there are mostly 2 big / common tools for this, described in the following paragraphs.

They all seems to have some downsides/complications, not completely sure what to use.
My first thought is to setup local backups first, to get a good feeling and not to worry
too much about using these secret management tools. It'll help me get a grasp on the backup solutions.
Then after I'm a bit more experienced with whatever backup tool I end up using, I'll figure out
what secret management tool to use.

### agenix

Pros:

- natively supports using ssh keys for decryption, though _not_ ssh keys with a password
- seems a bit simpler in use/setup, but not completely sure on this. Maybe good to try them both and see what sticks.
- Used in this article which seems relatively straightforward to follow: https://www.arthurkoziel.com/restic-backups-b2-nixos/

Cons:

- Seems to have a bit less features than sops-nix, but I'll have to figure out what I actually need

### sops-nix

Pros:

- Can use a KMS tool / backup, so maybe I could setup OpenBAO (Hashicorp Vault alternative) and use that
    - But not sure how that's supposed to work and haven't found / read the documentation on that yet
    - Seems like I'll need a server running somewhere
- Supports yubikey in some kind of way, which may be a good alternative to using private ssh keys

Cons:

- no native support for ssh keys for decryption, but support for deriving an `age` key from an ssh key
    - what about ssh keys with a password here?
