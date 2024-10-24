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
    rev = "2ce8334933ff267a26288cefccb287178b86a335";
    hash = "sha256-YdJEyHeuY2AibpV/SC+3f2B4anQqoDa3cqZ1lIjmS6k=";
  };
  vendorHash = "sha256-Vfh/MZXDOGduWnuR8f80peKjlk68shBKHyrSheinaZQ=";
}
