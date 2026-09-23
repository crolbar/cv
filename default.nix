{
  stdenv,
  roboto,
  typst,
  age,
  writeShellApplication,
  lang ? "en",
  public ? true,
} @ _in: let
  pname = "cv";
in
  stdenv.mkDerivation {
    inherit pname;
    version = "";
    src = ./.;

    buildPhase = ''
      runHook preBuild

      mkdir -p $out
      ln -s ${import ./script.nix _in}/* $out

      runHook postBuild
    '';
  }
