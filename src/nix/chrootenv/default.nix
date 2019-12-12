let
  pkgs = import <nixpkgs> {};
  chrootenv = pkgs.callPackage (pkgs.path +
    "/pkgs/build-support/build-fhs-userenv/chrootenv/") {};
in
  chrootenv
