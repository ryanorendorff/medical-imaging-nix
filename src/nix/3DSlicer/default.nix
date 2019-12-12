# This defines a function taking in some other packages. This type of function
# is usually called with`callPackage`, which will automatically fill out these
# parameters based on their name.
{ pkgs
, stdenv
, fetchurl
, buildFHSUserEnv
, unzip
, makeDesktopItem
, runCommand
, bash
}:

let
  version = "4.10.2";

  # The icon file is not included in the linux package, so we grab it from the
  # github repository.
  icon = fetchurl {
    url = "https://github.com/Slicer/Slicer/raw/b26a7eefc2813d04bd1005be6dd6ccc41984154a/Resources/3DSlicerLogo-app-icon.svg";
    sha256 = "1gg82dwgrlbjq22s1s7lzylnhn70r4drhwi8vh4n1yy7wj6nsk2q";
  };

  slicerSrc = stdenv.mkDerivation rec {
    inherit version;
    name = "slicer-${version}-pkg";

    src = fetchurl {
      url = "http://slicer.kitware.com/midas3/download/item/435293/Slicer-4.10.2-linux-amd64.tar.gz";
      sha256 = "1x92120v055qjs6yapjjpcp9wp4ajd9qpgdzgqbnk1j2c8nl5c31";
    };

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      # `$out` is an input given to this stage.
      mkdir -p $out
      cp -r * $out

      # automatically populate the MPI colormap into the slicer interface
      cp ${./COLORMAP.txt} $out/share/Slicer-4.10/ColorFiles/COLORMAP.txt
    '';
  };

  fhsEnv = buildFHSUserEnv {
    name = "3DSlicer-fhs-env";

    targetPkgs = pkgs: with pkgs; with xorg; [
      alsaLib
      dbus
      expat
      ffmpeg
      fontconfig
      freetype
      glib
      libGL
      libGLU
      libICE
      libSM
      libX11
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXt
      libXtst
      libpulseaudio
      libxcb
      nspr
      nss
      zlib
    ];

    # Call slicer from the command line with desired file to open.
    runScript = "${slicerSrc}/Slicer";

    # Slicer includes most of its own dependencies bundled in (such as Qt), so
    # we just need to tell slice where to find the files.
    profile = ''
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib64:${slicerSrc}/lib
    '';

  };

  desktopItem = makeDesktopItem {
    name = "Slicer";
    exec = "slicer";
    inherit icon;
    type = "Application";
    comment = meta.description;
    desktopName = "Slicer";
    genericName = "Medical Image Viewer";
    categories = "MedicalSoftware";
  };

  # Some metadata associated with the package to assist with package lookup.
  meta = with stdenv.lib; {
      homepage = "https://www.slicer.org/";
      description = ''
        3D Slicer is an open source software platform for medical image
        informatics, image processing, and three-dimensional visualization.
        Built over two decades through support from the National Institutes of
        Health and a worldwide developer community, Slicer brings free, powerful
        cross-platform processing tools to physicians, researchers, and the
        general public.
      '';
      license = licenses.bsd3;
      platforms = platforms.linux;
  };

in

  # `runCommand` builds a derivation containing the script we wish to run, along
  # with some metadata about the derivation.
  runCommand "3DSlicer-${version}" { inherit meta; } ''

  # We want both a binary and a desktop item. Hence each will be placed in an
  # appropriate folder instead of just having the command directly.
  mkdir -p $out/bin

  # The script that will run when executing this package. It merely calls the
  # Slicer buildFHSUserEnv environment and passes any command line arguments
  # to the Slicer binary.
  cat >$out/bin/Slicer <<EOF
#!${bash}/bin/bash
exec ${fhsEnv}/bin/3DSlicer-fhs-env "\$@"
EOF
  chmod +x $out/bin/Slicer

  # Put the desktop icon file in the right place.
  mkdir -p $out/share/applications
  cp ${desktopItem}/share/applications/* $out/share/applications/
''
