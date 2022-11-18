let
  haskellNix = import (builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/d54e2821c69b830cfa03dc47d18891797647b6da.tar.gz") { };
  # Import nixpkgs and pass the haskell.nix provided nixpkgsArgs
  pkgs = import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs;
in pkgs.haskell-nix.project {
  # 'cl eanGit' cleans a source directory based on the files known by git
  src = pkgs.haskell-nix.haskellLib.cleanGit {
    name = "haskell-nix-project";
    src = ./.;
  };
  # Specify the GHC version to use.
  compiler-nix-name = "ghc924"; # Not required for `stack.yaml` based projects.
  # nix output monitor
}