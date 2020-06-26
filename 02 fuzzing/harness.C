// harness for fuzzing of xyz files
// replace parser variable with any other parser (found in ParseFile.C) to fuzz other formats

#include "XyzParser.h"
#include <string>
using namespace IQmol::Parser;

int main(int argc, char **argv)
{
    __AFL_INIT();

    while (__AFL_LOOP(1000))
    {
        Base *parser = new Xyz;
        QString input = QString::fromStdString(argv[1]);
        parser->parseFile(input);
    }
    return 0;
}