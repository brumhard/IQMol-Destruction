// harness for fuzzing of xyz files
// replace parser variable with any other parser (found in ParseFile.C) to fuzz other formats

#include "XyzParser.h"
#include <string>
using namespace IQmol::Parser;

__AFL_FUZZ_INIT();

int main(int argc, char **argv)
{
    __AFL_INIT();

    unsigned char *buf = __AFL_FUZZ_TESTCASE_BUF;

    while (__AFL_LOOP(1000))
    {
        int len = __AFL_FUZZ_TESTCASE_LEN;

        Base *parser = new Xyz;
        std::string inputBufString(reinterpret_cast<char const *>(buf));
        QString input = QString::fromStdString(inputBufString);
        parser->parseFile(input);
    }
    return 0;
}
