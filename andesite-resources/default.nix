{stdenv, zip}:
stdenv.mkDerivation {
    name = "andesite-resources";
    src = ./.;
    buildInputs = [zip];
    phases = ["unpackPhase" "buildPhase" "installPhase"];
    buildPhase = ''
        zip --recurse-paths andesite-resources.zip \
            pack.mcmeta assets
    '';
    installPhase = ''
        mkdir $out
        mv andesite-resources.zip $out
    '';
}
