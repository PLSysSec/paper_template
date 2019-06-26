{ nixpkgs ? import <nixpkgs> {} }: with nixpkgs;
stdenv.mkDerivation {
  name = "paper";
  buildInputs = [ texlive.combined.scheme-full
                  python3
                  git
                  jq
                ];
}
