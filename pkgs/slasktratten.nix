{ stdenv, fetchurl, writeText, writeScriptBin, coreutils, jdk, openssh, unison }:

stdenv.mkDerivation rec {
  name = "slasktratten-${version}";
  version = "0.1.0";
  src = writeText "slasktratten.txt" ''
    Nopes, inget här..
  '';
  buildInputs = [ jdk openssh unison ];
  phases = [ "installPhase" ];
  installPhase =
    let
    kouchat = writeScriptBin "kouchat" ''
      #!/bin/sh
      ${jdk}/bin/java -jar ${(fetchurl {
        url = "https://github.com/blurpy/kouchat/releases/download/kouchat-1.2.0/kouchat-1.2.0.jar";
        sha256 = "0lwxl1r2jyz9vwx1np2f27zsys8fpin6pr3halzsmnlk76aar17y";
      })} $@
    '';
    in
    ''
      mkdir -p $out/bin
      ln -s ${kouchat}/bin/kouchat $out/bin
    '';
}
