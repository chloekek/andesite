{stdenv, closureInfo, andesite, andesite-www, dpkg}:
let
    closure =
        closureInfo {
            rootPaths = [
                andesite
                andesite-www
            ];
        };
in
stdenv.mkDerivation {
    name = "andesite-package";
    src = ./.;
    buildInputs = [dpkg];
    phases = ["unpackPhase" "buildPhase" "installPhase"];
    buildPhase = ''
        VERSION=$(< ${../VERSION})

        mkdir --parents andesite/DEBIAN
        mkdir --parents andesite/etc/systemd/system
        mkdir --parents andesite/usr/lib/andesite/bin
        mkdir --parents andesite/usr/lib/andesite/nix-store

        sed "s/«VERSION»/$VERSION/g" debian/control > andesite/DEBIAN/control
        cp debian/postinst andesite/DEBIAN/postinst
        cp systemd/andesite.service andesite/etc/systemd/system/andesite.service

        for storePath in $(< ${closure}/store-paths); do
            cp -R $storePath andesite/usr/lib/andesite/nix-store
        done

        ln -s ${andesite}/bin/andesite andesite/usr/lib/andesite/bin/andesite
        ln -s ${andesite-www}/bin/andesite-www andesite/usr/lib/andesite/bin/andesite-www

        dpkg-deb -Znone --build andesite
    '';
    installPhase = ''
        mkdir $out
        mv andesite.deb $out
    '';
}
