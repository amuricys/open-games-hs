let
  haskellProject = import ./default.nix;
  ghcVersion = "ghc924";
in
haskellProject.shellFor {
  buildInputs = [
    haskellProject.pkgs.graphviz
  ];
  tools = {
    cabal = "latest";
    hlint = "latest";
    haskell-language-server = "latest";
    ormolu = "latest";
  };
}
