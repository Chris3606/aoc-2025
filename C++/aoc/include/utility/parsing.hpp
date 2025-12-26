#pragma once
#include <fstream>
#include <sstream>
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

    template <typename T>
    std::vector<T> ParseDelimited(std::istream& input_file, char delimiter)
    {
        std::vector<T> result;
        std::string token;
        while (std::getline(input_file, token, delimiter))
        {
            T obj;
            std::istringstream token_stream(token);
            token_stream >> obj;
            result.push_back(obj);
        }
        return result;
    }

}  // namespace aoc