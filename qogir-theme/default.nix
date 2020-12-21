{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "qogir-theme";
  version = "2020-02-26";

  # TODO mauybe update this.
  src = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "1s14knj0ral5a62ymwbg5k5g94v8cq0acq0kyam8ay0rfi7wycdm";
  };

  buildInputs = with pkgs; [ gdk-pixbuf librsvg optipng inkscape_0 which ];

  propagatedUserEnvPkgs = with pkgs; [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .

    cd src/xfwm4/
    rm assets.svg render-assets.sh themerc assets/*
    cp ${./assets.svg} ./assets.svg
    cp ${./render-assets.sh} ./render-assets.sh
    cp ${./themerc} ./themerc
    bash ./render-assets.sh
    cd ../../

    mkdir -p $out/share/themes
    name= ./install.sh -d $out/share/themes
    mkdir -p $out/share/doc/${pname}
    cp -a src/firefox $out/share/doc/${pname}
    rm $out/share/themes/*/{AUTHORS,COPYING}
  '';

  meta = with pkgs.stdenv.lib; {
    description = "Flat Design theme for GTK based desktop environments";
    homepage = "https://vinceliuice.github.io/Qogir-theme";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}

