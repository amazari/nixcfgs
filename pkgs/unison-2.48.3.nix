{stdenv, fetchurl, ocaml, lablgtk, fontschumachermisc, xset, makeWrapper, ncurses
, enableX11 ? true}:

stdenv.mkDerivation (rec {

  name = "unison-" + version;
  version = "2.48.3";

  passthru = { inherit version; };

  src = fetchurl {
    url = "http://www.seas.upenn.edu/~bcpierce/unison/download/releases/stable/${name}.tar.gz";
    sha256 = "10sln52rnnsj213jy3166m0q97qpwnrwl6mm529xfy10x3xkq3gl";
  };

  buildInputs = [ ocaml makeWrapper ncurses ];

  preBuild = if enableX11 then ''
    sed -i "s|\(OCAMLOPT=.*\)$|\1 -I $(echo "${lablgtk}"/lib/ocaml/*/site-lib/lablgtk2)|" Makefile.OCaml
  '' else "";

  makeFlags = "INSTALLDIR=$(out)/bin/" + (if enableX11 then " UISTYLE=gtk2" else "")
    + (if ! ocaml.nativeCompilers then " NATIVE=false" else "");

  preInstall = "mkdir -p $out/bin";

  postInstall = if enableX11 then ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i \
        --run "[ -n \"\$DISPLAY\" ] && (${xset}/bin/xset q | grep -q \"${fontschumachermisc}\" || ${xset}/bin/xset +fp \"${fontschumachermisc}/lib/X11/fonts/misc\")"
    done
  '' else "";

  dontStrip = !ocaml.nativeCompilers;

  meta = {
    homepage = http://www.cis.upenn.edu/~bcpierce/unison/;
    description = "Bidirectional file synchronizer";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

})
