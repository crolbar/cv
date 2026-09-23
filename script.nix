{
  roboto,
  typst,
  age,
  writeShellApplication,
  name ? "cv",
  lang ? "en",
  public ? true,
  ...
}: let
  mainFile = "cv.typ";
  ageId = "~/.ssh/id_rsa"; # TODO
  bts = b:
    if b
    then "true"
    else "false";
in
  writeShellApplication {
    name = name;
    runtimeInputs =
      [typst]
      ++ (
        if !public
        then [age]
        else []
      );
    text = ''
      inputs="--input lang=${lang}"
      if [[ -n "''${1+x}" ]]; then
        inputs="--input lang=$1"
      fi
      pub=${bts public}

      if [[ "$pub" == false || (! -z "''${2+x}" && "$2" == "p") ]]; then
        tmp_sec=".cv_sec"
        trap 'rm -f "$tmp_sec"' EXIT

        age -d -i ${ageId} data.age > "$tmp_sec"
        inputs="$inputs --input secret_file=$tmp_sec"
      fi

      export TYPST_FONT_PATHS="${roboto}/share/fonts/truetype/"

      # shellcheck disable=SC2086
      typst compile ${mainFile} $inputs
    '';
  }
