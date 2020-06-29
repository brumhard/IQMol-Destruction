# Fuzzing

> build the parser as described [here](installation.md)

## target
- test complexity with http://www.lizard.ws/ & cppcheck
- -> FormattedCheckpoint, QChemInput, QChemOutput
  - FCHK very static
  - QChemOutput huge files
  - -> QChemInput (also already in problem files)
  
  

## fuzzing instructions old
- make machine rdy: run `sudo afl-system-config`
- create needed dirs eg. in IQmol repo root
  - `mkdir fuzzing fuzzing/in fuzzing/out fuzzing/in_min`
- copy all sample files to 
  - `cp samples/* fuzzing/in/`
  - `cp src/Parser/test/problems/* fuzzing/in/`
  - `cp src/Parser/test/samples/ fuzzing/in/`
- copy build main to fuzzing dir: `cp IQmol fuzzing/parser`

## fuzzing instructions new
- take (.inp) files from sample folders
- build dictionary from [format definition](https://www.q-chem.com/qchem-website/manual/qchem43_manual/tab-keywords.html) -> see [dict](inp.dict)
- minimize corpus -> `afl-cmin`
- minimize test cases -> `afl-tmin`
- parallel fuzzing with asan, dictionary (see [commands](parallel_fuzz))
- minimize crashes with [crashwalk](https://github.com/bnagy/crashwalk)
- run fuzzing with `-C` option (see [here](https://github.com/AFLplusplus/AFLplusplus/blob/master/docs/technical_details.md#9-investigating-crashes)) with crashes as input
- enjoy crashes

## what we learned
- you cannot parse all file formats as the parser detects format on file extension and afl cuts the extension when using `@@`
- because of this use either `-f test.<extension>` or `-e <extension>` as cli options for `afl-fuzz`
- resulting command could be: `afl-fuzz -i in_out -o out_out/ -m none -e out -- ./parser_qt -platform offscreen @@`
- building openbabel with afl isn't working (see [installation](installation.md))
- shared memory mode is insanely fast, but not really usable for later testing with input files


## TODO
- [x] minimize harness to point to one parser statically
- [x] deferred fork server & persistent mode -> see new harnesses([harness](harness.C), [shared_mem](harness_shared_wip.C))
- [x] dictionary
- [ ] harness read from stdin
- [x] harness read from shared memory as shown [here](https://github.com/AFLplusplus/AFLplusplus/blob/master/llvm_mode/README.persistent_mode.md), new feature
  - [x] -> use parser parse method directly with textstream
- [x] minimze input file size
- [x] parallelize with one asan build


