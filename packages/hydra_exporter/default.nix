{
  buildGoModule,
  fetchFromGitHub,
  ...
}:

buildGoModule {
  pname = "hydra_exporter";
  version = "unstable-2023-07-20";
  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "hydra_exporter";
    rev = "a68d9bd5351c9502d4eacf38241ef7f5bd373a81";
    hash = "sha256-3BVpvTVYC3J8OWY4MrQ3+jiMIk6FInMErzWin3BZL/Q=";
  };
  vendorHash = "sha256-Vfh/MZXDOGduWnuR8f80peKjlk68shBKHyrSheinaZQ=";
}
