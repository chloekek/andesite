{stdenv, fetchurl}:
let
    jar = fetchurl {
        url = "https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar";
        sha256 = "0aapiwgx9bmnwgmrra9459qfl9bw8q50sja4lhhr64kf7amyvkay";
    };
in
stdenv.mkDerivation {
    name = "minecraft";
    phases = ["installPhase"];
    installPhase = ''
        mkdir $out
        cp ${jar} $out/server.jar
    '';
}
