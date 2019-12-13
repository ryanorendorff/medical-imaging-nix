let

  # 19.03 on Oct 1st 2019
  nixpkgs-src = builtins.fetchTarball {
    url =
      "https://github.com/NixOS/nixpkgs-channels/archive/91d04b9b23c3e94183f829bf411237ad0241cc8e.tar.gz";
    sha256 = "165ckvrzj57c9znvvh42brbimfsffnnikxdr6mfxz6lqnxz8wvpa";
  };

  srcOnly = (import nixpkgs-src { }).srcOnly;

  nixpkgs = srcOnly {
    name = "nixpkgs-root";
    src = nixpkgs-src;
    patches = [ ./lets-change-something.patch ];
  };

in import "${nixpkgs}/nixos" {
  system = "x86_64-linux";
  configuration = import ./configuration.nix;
}
