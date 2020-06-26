// harness for fuzzing of xyz files
// replace parser variable with any other parser (found in ParseFile.C) to fuzz other formats

#include "XyzParser.h"
#include "TextStream.h"
#include <string>
#include <iostream>
using namespace IQmol::Parser;

__AFL_FUZZ_INIT();

int main(int argc, char **argv)
{
    unsigned char *buf;

    __AFL_INIT();
    buf = __AFL_FUZZ_TESTCASE_BUF;

    while (__AFL_LOOP(1000))
    {
        Base *parser = new Xyz;
        std::string inputBufString(reinterpret_cast<char const *>(buf));
        QString input = QString::fromStdString(inputBufString);
        TextStream textStream(&input);
        parser->parse(textStream);
    }
    return 0;
}
