{ stdenv
, alsaLib
, autoPatchelfHook
, dbus
, fontconfig
, freetype
, glib
, krb5
, libglvnd
, libICE
, libSM
, libX11
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXi
, libxkbcommon
, libXrandr
, libXrender
, libXtst
, makeWrapper
, nss
, python38
, requireFile
, systemd
, unzip
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, xcbutilwm
, xkeyboardconfig
, zlib
}:
stdenv.mkDerivation rec {
  pname = "binary-ninja-personal";
  version = "2.2.2487";

  src = requireFile {
    name = "BinaryNinja-personal.zip";
    url = "https://binary.ninja";
    sha256 = "ed1f3437a803dc7942383343d6d7788d7cfdee142fb3da6182a5e03e09e8e6b4";
  };

  buildInputs = [
    alsaLib
    autoPatchelfHook
    dbus
    fontconfig
    freetype
    glib
    krb5
    libglvnd
    libICE
    libSM
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXi
    libxkbcommon
    libXrandr
    libXrender
    libXtst
    makeWrapper
    nss
    python38
    stdenv.cc.cc.lib
    unzip
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
    zlib
  ];

  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/lib $out/bin $out/share
    mv $NIX_BUILD_TOP/$sourceRoot $out/lib/binary-ninja
    makeWrapper $out/lib/binary-ninja/binaryninja $out/bin/binaryninja \
        --suffix LD_LIBRARY_PATH : "${systemd}/lib" \
        --suffix LD_LIBRARY_PATH : "${python38}/lib" \
        --set QT_XKB_CONFIG_ROOT "${xkeyboardconfig}/share/X11/xkb" \
        --set QTCOMPOSE "${libX11.out}/share/X11/locale"

    # Keeping the zip file in the nix store is desirable,
    # because when the zip is missing requireFile involves manual steps.
    # Below is just a hack to keep the zip from being garbage-collected.
    ln -s "${src}" "$out/share/BinaryNinja-personal.zip"
  '';
}
