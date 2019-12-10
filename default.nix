let

  pkgs = import (builtins.fetchTarball {
    url =
      "https://github.com/NixOS/nixpkgs-channels/archive/3a1861fcabcdf08a0c369e49b48675242ceb3aa2.tar.gz";
    sha256 = "0sh2b4kb9vl4vz1y4mai986rlx80nsiv25f2lmdq06m5q7l0n0k9";
  }) { };

  inherit (pkgs) stdenv lib;

in stdenv.mkDerivation {
  pname = "medical-imaging-nix.md";
  version = "0.1.0";

  src = ./src;

  buildInputs = with pkgs; [
    (texlive.combine {
      inherit (texlive)
        scheme-small beamer beamertheme-metropolis pgfopts lm-math;
    })

    pandoc
    coreutils
    haskellPackages.pandoc-crossref
  ];

  installPhase = ''
    mkdir $out
    cp medical-imaging-nix.pdf $out
  '';

}
