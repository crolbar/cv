# cv made with typst + nix

This is the initial template for a cv that has 4+ versions, the building of
which is done with nix + builder script in `./script.nix`.\
The main typst file is `./cv.typ` which uses `./data_*.typ` files to get the
data. (`*` being the language the data is written in)\
Language can be set by passing an input to typst with `--input lang=pl`
argument.

Additionally the input `secret_file` (`--input secret_file=./sec`) can be
passed, as it points to a file that will be used at build time to overwrite data
from `data_*.typ`.\
This is used to get secrets from `./data.age` into the final output.

## Building

```
nix run
```

> Using run so we don't expose the pdf to the nix store.\
> We are essentially using nix to create a bulider that uses typst to build the
> pdf, outputing it in the current directory.

or a specific one

```
nix run .#private_en
```

or using the script from the devshell

```
cv bg p
```

- Exposed packages: (versions)
  - default: pub_en
  - public_en: using public data defined in `data_en.typ`
  - public_bg: using public data defined in `data_bg.typ`
  - private_en: using `data.age` to replace data in `data_en.typ`
  - private_bg: using `data.age` to replace data in `data_bg.typ`
