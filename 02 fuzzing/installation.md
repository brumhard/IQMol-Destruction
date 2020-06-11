# IQMol Fuzzing


## fuzzing files
- [harness](harness.C): copy to `src/Parser/test` and rename to main.C; then run `qmake` & `make`, which will result in a minimal Parser harness `./Parser`
- [new build config](linux.pri) see [installation notes](#installation-notes) and [afl instructions](#afl-instructions)

## installation notes
> this uses the normal compiler, look [here](#afl-instructions) for afl compiling
- `git clone https://github.com/nutjunkie/IQmol.git`
- `sudo apt install g++ git gfortran cmake qt5-default libssl-dev openssl libssh2-1-dev libboost-dev libboost-serialization-dev libboost-iostreams-dev libopenbabel-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev`
> every pro file imports common.pri, linux.pri -> make config changes here
- fortran build in src/Main:
  - `gfortran -c Main/symmol.f90`
  - move resulting symmol.o from src/Main to build: `cp Main/symmol.o ../build`
- in linux.pri:
  - uncomment CONFIG += DEVELOP in line 2 -> to get it to work with prod/deploy settings, see [here](#instructions-for-prod)
  - comment CONFIG += DEPLOY, otherwise openbabel is required in DEV path
  - gfortran libs are not up to date -> rename all occurences:
    - /usr/lib/gcc/x86_64-linux-gnu/5/libgfortran.a -> /usr/lib/gcc/x86_64-linux-gnu/7/libgfortran.a
    - /usr/lib/gcc/x86_64-linux-gnu/5/libquadmath.a -> /usr/lib/gcc/x86_64-linux-gnu/7/libquadmath.a
  > you can also copy the [linux.rpi](linux.pri) file contained in this repo to src/ and replace the old one 
- in src:
  - qmake IQmol.pro
  - make
- this will result in the executable "IQmol" in the root dir
- to build standalone parser:
  > !!! outdated see [here](#parser-standalone-instructions)
  > src/Parser/ contains Readme which states that you need to uncomment a line in Parser.pro, this doesnt seem to have any effect
  - instead go to src/Parser/test and then run qmake, make to get a Parser executable in the test dir
  - run with `./Parser -platform offscreen` for headless mode
  > this doesnt return proper exit codes -> use harness as described in [fuzzing files](#fuzzing-files)

## afl instructions
- Prepare the OS for AFL
  - `echo core | sudo tee /proc/sys/kernel/core_pattern`
  - `echo 0 | sudo tee /proc/sys/kernel/randomize_va_space`
- clone afl++ repo: `git clone https://github.com/AFLplusplus/AFLplusplus.git`
- requirements: `sudo apt install build-essential libtool-bin python3-dev automake autoconf flex bison libglib2.0-dev libpixman-1-dev clang python3-setuptools llvm clang-9`
- build with clang fast: `LLVM_CONFIG=llvm-config-9 make distrib` or maybe change version according to your clang version
- restart shell to update path
- install to path: `sudo make install`
- restart shell
- enter the following:
  ```
  QMAKE_CC=afl-clang-fast
  QMAKE_CXX=afl-clang-fast++  
  QMAKE_LINK=afl-clang-fast++
  ```
  into linux.pri in src
- comment out QMAKE_CC and QMAKE_CCX options in compiler.include
- as these files are included in all pro files, this should transport the compiler options to all makefiles
- build: `make clean all`

## parser standalone instructions
- take [harness](harness.C), rename to `main.C` and replace `main.C` in src/Main
- build with afl as described in [afl instructions](#afl-instructions)

## instructions for prod:
- download openbabel: `wget https://github.com/openbabel/openbabel/releases/download/openbabel-3-1-1/openbabel-3.1.1-source.tar.bz2`
- unpack: `tar xvf openbabel-3.1.1-source.tar.bz2`
- `mkdir build && cd build`
- `cmake ../`
- `make`
- `sudo make install`
- copy `babelconfig.h` from `build/include/openbabel/babelconfig.h` to `include/openbabel/babelconfig.h`
  - from root of openbabel: `cp build/include/openbabel/babelconfig.h include/openbabel/`
- replace openbabel config in deploy section of linux pri to:
  ```
    INCLUDEPATH += <path to openbabel installation>
    LIBS        += -lopenbabel
  ```
- make sure that in the first 2 lines of linux.pri deploy is enabled and develop is commented

## qt installation/ build
> this doesnt seem to be essential
- download QT: `wget http://download.qt.io/official_releases/qt/5.15/5.15.0/single/qt-everywhere-src-5.15.0.tar.xz`
  - unpack: `tar xvf qt-everywhere-src-5.15.0.tar.xz`
  - `./configure`
  - `make`
  - `make install`
  - -> qt installation no available in `/usr/local/Qt-5.15.0`

## general notes
- samples in samples/ and src/Parser/test/samples
- even problem files folder: src/Parser/test/problems
- cml file: https://fileinfo.com/extension/cml#:~:text=What%20is%20a%20CML%20file,exchanging%20and%20archiving%20chemical%20data. as additional fuzzing target?
- uses openbabel file parsers -> https://github.com/openbabel/openbabel/search?q=ReadMolecule+in%3Afile&unscoped_q=ReadMolecule+in%3Afile
  - all file parsers here implement `ReadMolecule` method
  - this is needed in openbabel/obconversion.h and obconversion. where all formats are registered
  - used in `OBConversion::Read` in obconversion.cpp
  - also implements own xml parser? https://github.com/openbabel/openbabel/blob/66042e0d98ff75556a1a52e3fc0ce1a2ec76d2fd/src/formats/xml/xml.cpp

## openbabel
> this doesnt work i guess, produces address sanitizer bugs
- wget https://github.com/openbabel/openbabel/archive/openbabel-2-4-1.tar.gz
- tar xzf openbabel-2-4-1.tar.gz
- mkdir build
- cd build
- CC=afl-clang-fast CXX=afl-clang-fast++ cmake -static ..
- make