# Part of the Galil Toolkit (GDK)
{ stdenv, lib, dpkg }:

stdenv.mkDerivation rec {

  name = "gclib-${version}";
  version = "444-1";

  # You'll have to download this from the galil repository
  src = ./gclib_444-1_amd64.deb;

  nativeBuildInputs = [ dpkg ];

  buildInputs = [ stdenv.cc.cc.lib ];

  unpackPhase = "dpkg -x $src .";

  installPhase = ''
    mkdir -p $out/include
    mkdir -p $out/lib
    mkdir -p $out/share

    cp usr/lib/lib* $out/lib/
    cp -dr usr/share/doc $out/share/
    cp usr/include/*.h $out/include/

    pushd $out/lib
    ln -s libgclib.so.0.444 libgclib.so.0
    ln -s libgclibo.so.0.0  libgclibo.so.0
  '';

  preFixup = let libPath = lib.makeLibraryPath [ stdenv.cc.cc.lib ];
  in ''
    for f in $out/lib/lib* ; do
      patchelf --set-rpath "${libPath}:$out/lib" $f
    done
  '';

}
