# CONFIG += DEPLOY
CONFIG += DEVELOP


QMAKE_CC=afl-clang-fast
QMAKE_CXX=afl-clang-fast++ 
QMAKE_LINK=afl-clang-fast++
OPTION += create_prl
OPTION += static

contains(CONFIG, DEVELOP){
   #message("---- DEVELOP set ----")

   INCLUDEPATH += /usr/local/include
   LIBS        += -L/usr/local/lib

   # Boost
   LIBS        += -lboost_iostreams -lboost_serialization
   
   # OpenBabel
   INCLUDEPATH += /usr/include/openbabel-2.0
   LIBS        += -lopenbabel

   # SSH2/libssl/crypto
   LIBS        += -lssh2 -lssl -lcrypto

   # gfortran
   LIBS        += /usr/lib/gcc/x86_64-linux-gnu/7/libgfortran.a
   LIBS        += /usr/lib/gcc/x86_64-linux-gnu/7/libquadmath.a # required for gfortran 5

   # Misc
   LIBS        += -lz -ldl

   # QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/../lib\''
}


contains(CONFIG, DISTRIB) {
   #message("---- DISTRIB set ----")

   CONFIG += release
 
   INCLUDEPATH += /usr/local/include
   LIBS        += -L/usr/local/lib

   # Boost
   LIBS        += /usr/lib/x86_64-linux-gnu/libboost_serialization.a
   LIBS        += /usr/lib/x86_64-linux-gnu/libboost_iostreams.a
   
   # OpenBabel
   INCLUDEPATH += /usr/include/openbabel-2.0
   LIBS        += -lopenbabel

   # libssl/crypto
   LIBS        += /usr/lib/x86_64-linux-gnu/libcrypto.a /usr/lib/x86_64-linux-gnu/libssl.a 

   # SSH2/gcrypt
   LIBS        += /usr/lib/x86_64-linux-gnu/libssh2.a
   LIBS        += /usr/lib/x86_64-linux-gnu/libgcrypt.a /usr/lib/x86_64-linux-gnu/libgpg-error.a

   # gfortran
   LIBS        += /usr/lib/gcc/x86_64-linux-gnu/7/libgfortran.a
   LIBS        += /usr/lib/gcc/x86_64-linux-gnu/7/libquadmath.a # required for gfortran 5

   # Misc
   LIBS        += -lz -ldl

   # QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/../lib\'' 
}
 

contains(CONFIG, DEPLOY) {
   #message("---- DEPLOY set ----")

   CONFIG      += release
 
   INCLUDEPATH += /usr/local/include
   LIBS        += -L/usr/local/lib

   # Boost
   LIBS        += /usr/lib/x86_64-linux-gnu/libboost_serialization.a
   LIBS        += /usr/lib/x86_64-linux-gnu/libboost_iostreams.a
   
   # OpenBabel
   OPENBABEL    = $(DEV)/openbabel-2.4.1
   INCLUDEPATH += $${OPENBABEL}/include
   LIBS        += $${OPENBABEL}/build/src/libopenbabel.a

   # libssl/crypto
   LIBS        += /usr/lib/x86_64-linux-gnu/libcrypto.a 
   LIBS        += /usr/lib/x86_64-linux-gnu/libssl.a 

   # SSH2/gcrypt
   LIBS        += /usr/lib/x86_64-linux-gnu/libssh2.a
   LIBS        += /usr/lib/x86_64-linux-gnu/libgcrypt.a 
   LIBS        += /usr/lib/x86_64-linux-gnu/libgpg-error.a

   # gfortran
   LIBS        += /usr/lib/gcc/x86_64-linux-gnu/7/libgfortran.a
   LIBS        += /usr/lib/gcc/x86_64-linux-gnu/7/libquadmath.a # required for gfortran 5

   # Misc
   LIBS        += -lz -ldl

   # QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/../lib\'' 
}
