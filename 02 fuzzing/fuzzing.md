# Fuzzing

> build the parser as described [here](installation.md)

## fuzzing instructions
- make machine rdy: run `sudo afl-system-config`
- create needed dirs eg. in IQmol repo root
  - `mkdir fuzzing fuzzing/in fuzzing/out fuzzing/in_min`
- copy all sample files to 
  - `cp samples/* fuzzing/in/`
  - `cp src/Parser/test/problems/* fuzzing/in/`
  - `cp src/Parser/test/samples/ fuzzing/in/`
- copy build main to fuzzing dir: `cp IQmol fuzzing/parser`

## what we learned
- you cannot parse all file formats as the parser detects format on file extension and afl cuts the extension when using `@@`
- because of this use either `-f test.<extension>` or `-e <extension>` as cli options for `afl-fuzz`
- resulting command could be: `afl-fuzz -i in_out -o out_out/ -m none -e out -- ./parser_qt -platform offscreen @@`
- a minimized out file to be run with the above command can be found [here](out_min.out)
- building openbabel with afl isn't working (see [installation](installation.md))

## optimizations
- for some formates don't use sample files, just start fuzzing with an a in the file (`echo "a" > in_file.xyz`)
- add defered fork server mode to skip init in main.C
  - add `__AFL_INIT();` after `initOpenBabel();` line in `parse` method
- 

## TODO
- minimize harness
- minimze input file size
- read from stdin


