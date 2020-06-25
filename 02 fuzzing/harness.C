// harness for fuzzing of xyz files
// replace parser variable with any other parser (found in ParseFile.C) to fuzz other formats

#include "XyzParser.h"
using namespace IQmol::Parser;

int main(int argc, char *argv[])
{
    Base *parser = new Xyz;
    QString input = QString::fromStdString(argv[1]);
    return int(parser->parseFile(input));
}