let nixpkgs = import ./nix/nixpkgs.nix {}; in
rec {
    andesite = nixpkgs.callPackage ./andesite
        {inherit andesite-resources;};

    andesite-package = nixpkgs.callPackage ./andesite-package
        {inherit andesite andesite-www;};

    andesite-resources = nixpkgs.callPackage ./andesite-resources
        {};

    andesite-www = nixpkgs.callPackage ./andesite-www
        {inherit andesite-resources;};
}
