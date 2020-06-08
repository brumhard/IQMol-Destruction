// harness for fuzzing

#include <string>
#include <iostream>
#include "ParseFile.h"
#include "openbabel/obconversion.h"

using namespace IQmol;

int main(int argc, char *argv[])
{
    std::string inputPath(argv[1]);

    // check if file exists
    std::ifstream test(inputPath);
    if (!test)
    {
        std::cout << "The file doesn't exist\n";
        std::cout << "Error parsing file\n";
        return 1;
    }

    // parse the file
    Parser::ParseFile parseFile(QString::fromStdString(inputPath));
    parseFile.start();
    parseFile.wait();

    // check for errors
    QStringList errors(parseFile.errors());
    if (!errors.isEmpty())
    {
        std::cout << "Error parsing file\n";
        return 1;
    }
    std::cout << "Successfully parsed file\n";
    return 0;
}