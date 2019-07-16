{stdenv, makeWrapper, andesite-resources, nginx}:
stdenv.mkDerivation {
    name = "andesite-www";
    phases = ["buildPhase" "installPhase"];
    buildInputs = [makeWrapper];
    buildPhase = ''
        sed 's#«WEBROOT»#${andesite-resources}#g' ${./nginx.conf} > nginx.conf
    '';
    installPhase = ''
        mkdir --parents $out/bin $out/share
        mv nginx.conf $out/share
        makeWrapper ${nginx}/bin/nginx $out/bin/andesite-www \
            --add-flags -c \
            --add-flags $out/share/nginx.conf
    '';
}
