{stdenv, makeWrapper, andesite-resources, jre, minecraft, perl, rakudo}:
stdenv.mkDerivation {
    name = "andesite";
    src = ./.;
    buildInputs = [makeWrapper rakudo];
    phases = ["unpackPhase" "installPhase"];
    installPhase = ''
        mkdir --parents $out/bin $out/share/doc

        sha1sum ${andesite-resources}/andesite-resources.zip \
            | cut -b 1-40 > resources/andesite-resources.zip.sha1

        ln -s ${minecraft}/server.jar resources/server.jar

        mv META6.json bin lib resources t $out/share

        makeWrapper \
            ${rakudo}/bin/perl6 \
            $out/bin/andesite \
            --prefix PATH : ${jre}/bin \
            --prefix PERL6LIB , $out/share \
            --add-flags $out/share/bin/andesite

        makeWrapper \
            ${perl}/bin/prove \
            $out/bin/andesite.test \
            --prefix PERL6LIB , $out/share \
            --add-flags --exec \
            --add-flags ${rakudo}/bin/perl6 \
            --add-flags --recurse \
            --add-flags $out/share/t
    '';
}
