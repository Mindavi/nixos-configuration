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
    hash = "sha256-YdJEyHeuY2AibpV/SC+3f2B4anQqoDb3cqZ1lIjmS6k=";
  };
  vendorHash = "sha256-Vfh/MZXDOGduWnuR8f80peKjlk68shBKHyrSheinaZQ=";
}
