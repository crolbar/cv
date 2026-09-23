{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = inputs: let
    systems = ["x86_64-linux" "aarch64-linux"];
    pkgsFor = system: import inputs.nixpkgs {inherit system;};
    forAllSystems = f: inputs.nixpkgs.lib.genAttrs systems (system: f (pkgsFor system));
  in {
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          typst
          typstyle
          tinymist
          (writers.writeBashBin "tw" "typst watch cv.typ")
          (writers.writeBashBin "ed" "AGEH_REC_FILE=./data-recipients ageh -e data.age")
          (callPackage ./script.nix {})
          age
        ];

        TYPST_FONT_PATHS = builtins.concatStringsSep ":" [
          "${pkgs.roboto}/share/fonts/truetype/"
        ];
      };
    });

    packages = forAllSystems (pkgs: rec {
      default = public_en;

      pen = public_en;
      public_en = pkgs.callPackage ./default.nix {
        lang = "en";
        public = true;
      };
      pbg = public_bg;
      public_bg = pkgs.callPackage ./default.nix {
        lang = "bg";
        public = true;
      };
      en = private_en;
      private_en = pkgs.callPackage ./default.nix {
        lang = "en";
        public = false;
      };
      bg = private_bg;
      private_bg = pkgs.callPackage ./default.nix {
        lang = "bg";
        public = false;
      };
    });
  };
}
