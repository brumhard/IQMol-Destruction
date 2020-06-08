# IQMol Fuzzing


### installation notes

- apt install g++ git gfortran cmake qt5-default libssl-dev openssl libssh2-1-dev libboost-dev libboost-serialization-dev libboost-iostreams-dev libopenbabel-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev
> Parser.pro imports common.pri, linux.pri
- fortran build in src/Main:
  - `gfortran -c symmol.f90`
  - move resulting symmol.o from src/Main to build
- in linux.pri:
  - uncomment CONFIG += DEVELOP in line 2 -> TODO: download newer qt and get it to work with prod settings
  - comment CONFIG += DEPLOY, otherwise openbabel is required in DEV path
  - gfortran libs are not up to date ->
    - /usr/lib/gcc/x86_64-linux-gnu/5/libgfortran.a -> /usr/lib/gcc/x86_64-linux-gnu/7/libgfortran.a
    - /usr/lib/gcc/x86_64-linux-gnu/5/libquadmath.a -> /usr/lib/gcc/x86_64-linux-gnu/7/libquadmath.a
  > you can also copy the linux.rpi file contained in this repo to src/ and replace the old one 
- in src:
  - qmake IQmol.pro
  - make
- this will result in the executable "IQmol" in the root dir
- to build standalone parser:
  > src/Parser/ contains Readme which states that you need to uncomment a line in Parser.pro, this doesnt seem to have any effect
  - instead go to src/Parser/test and then run qmake, make to get a Parser executable in the test dir
  - run with `./Parser -platform offscreen` for headless mode
  - TODO: add return 1 for failed parse in main Parser method (line 189?)
- assets: sudo mkdir /usr/share/iqmol (TODO: check if needed)
  - sudo mkdir /usr/share/iqmol
  - sudo cp -R ../share/\* /usr/share/iqmol

## general notes

- samples in samples/ and src/Parser/test/samples
- even problem files folder: src/Parser/test/problems

- cml file: https://fileinfo.com/extension/cml#:~:text=What%20is%20a%20CML%20file,exchanging%20and%20archiving%20chemical%20data. as additional fuzzing target?

- uses openbabel file parsers -> https://github.com/openbabel/openbabel/search?q=ReadMolecule+in%3Afile&unscoped_q=ReadMolecule+in%3Afile
  - all file parsers here implement `ReadMolecule` method
  - this is needed in openbabel/obconversion.h and obconversion. where all formats are registered
  - used in `OBConversion::Read` in obconversion.cpp
  - also implements own xml parser? https://github.com/openbabel/openbabel/blob/66042e0d98ff75556a1a52e3fc0ce1a2ec76d2fd/src/formats/xml/xml.cpp
