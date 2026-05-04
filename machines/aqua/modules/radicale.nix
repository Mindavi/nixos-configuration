{
  lib,
  ...
}:

{
  services.radicale = {
    enable = false;
    settings = {
      server = {
        # For now, just setup IPv6. Shouldn't really matter because we'll connect using localhost.
        hosts = [ "[::1]:5232" ];
      };
      auth = {
        # TODO(Mindavi): set back to 'htpasswd' after testing out.
        type = "none";
        # type = "htpasswd";
        htpasswd_filename = "/etc/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        filesystem_folder = "/var/lib/radicale/collections";
      };
      # Shared calendar support: https://github.com/Kozea/Radicale/wiki/Sharing-Collections
      # Just implemented in 3.7.0, which was released 2026-03-05.

      # Some hacks with symlinks are available, but probably best to use the official support since it's released.
      # Anyway, a link:
      # - https://pirogov.de/blog/radicale-shared-calendar/
    };
  };
}
