{
  buildGoModule,
  fetchFromGitHub,
  ...
}:

buildGoModule {
  pname = "hydra_exporter";
  version = "unstable-2025-07-02";
  src = fetchFromGitHub {
    owner = "Mindavi";
    repo = "hydra_exporter";
    rev = "ab8bfa778431586eeab67b02b28132db1b3eb34e";
    hash = "sha256-ZP4tM6RMU6W0NB5IUkrDTMLVuZR506ppVXxmyN5vJDI=";
  };
  vendorHash = "sha256-Vfh/MZXDOGduWnuR8f80peKjlk68shBKHyrSheinaZQ=";
}
