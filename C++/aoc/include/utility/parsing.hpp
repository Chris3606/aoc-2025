#pragma once
#include <fstream>
#include <string>
#include <vector>

namespace aoc
{
    template <typename T>
    std::vector<T> ParseLines(std::istream& input_file)
    {
        std::vector<T> result;
        std::string line;
        while (std::getline(input_file, line))
        {
            std::istringstream line_stream(line);
            T obj;
            line_stream >> obj;
            result.push_back(obj);
        }
        return result;
    };

}  // namespace aoc