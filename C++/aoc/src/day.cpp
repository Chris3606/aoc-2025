#include "day.hpp"

#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>

namespace fs = std::filesystem;

namespace aoc
{
    namespace
    {
        std::string _get_input_path(const std::string& input_file_name)
        {
            // File path to the source file, up two path leafs (to the main project directory)
            std::string dir(__FILE__);
            dir = dir.substr(0, dir.rfind(fs::path::preferred_separator));
            dir = dir.substr(0, dir.rfind(fs::path::preferred_separator));

            // From here, construct path into inputs/.
            return (fs::path(dir) / fs::path("inputs") / fs::path(input_file_name)).string();
        }
    }  // namespace

    DayBase::DayBase(int day) : m_day(day)
    {
    }

    void DayBase::solve(bool sample)
    {
        // Get file name for day based on inputted day and whether to use sample.
        std::stringstream sstream;
        sstream << std::setw(2) << std::setfill('0') << m_day;

        auto day_file_name = "day" + sstream.str() + (sample ? "_sample" : "") + ".txt";

        // Go from file name to path based on where the "inputs/" folder is
        auto input_path = _get_input_path(day_file_name);

        // Open file
        std::ifstream input_file(input_path);
        if (!input_file.is_open())
            throw std::runtime_error("Failed to open input file: " + input_path + ".");

        // Solve
        parse_and_process(input_file);
        input_file.close();
    }
}  // namespace aoc