{
  config,
  ...
}:
{
  # syncthing is available on http://127.0.0.1:8384/
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "rick";
    configDir = "/home/rick/.config/syncthing";
    dataDir = "/storage/documents/samba/rick_documents/";
    guiAddress = "0.0.0.0:8384";
  };
}
