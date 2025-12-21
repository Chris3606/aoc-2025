#include <cstddef>
#include <exception>
#include <iostream>
#include <string>
#include <vector>

#include "day.hpp"
#include "days/day00.hpp"
// #include "day01/solution.hpp"
// #include "day02/solution.hpp"
// #include "day03/solution.hpp"
// #include "day04/solution.hpp"
// #include "day05/solution.hpp"
// #include "day06/solution.hpp"
// #include "day07/solution.hpp"
// #include "day08/solution.hpp"
// #include "day09/solution.hpp"
// #include "day10/solution.hpp"
// #include "day11/solution.hpp"
// #include "day12/solution.hpp"

const std::vector<aoc::DayBase*> days{
    new aoc::Day00(),
    // new aoc::Day01(),
    // new aoc::Day02(),
    // new aoc::Day03(),
    // new aoc::Day04(),
    // new aoc::Day05(),
    // new aoc::Day06(),
    // new aoc::Day07(),
    // new aoc::Day08(),
    // new aoc::Day09(),
    // new aoc::Day10(),
    // new aoc::Day11(),
    // new aoc::Day12(),
};

int main(int argc, const char* argv[])
{
    if (argc < 2 || argc > 3 || (argc == 3 && std::string(argv[2]) != "-s"))
    {
        std::cerr << "Invalid usage: " << argv[0] << " <DAY> [-s]" << std::endl;
        return -1;
    }

    int day_num = 0;
    try
    {
        day_num = std::stoi(argv[1]);
    }
    catch (const std::exception& e)
    {
        std::cerr << "Usage error: Day given was not a valid integer." << std::endl;
        return -2;
    }

    const bool sample = argc == 3;

    if (day_num < 0 || (std::size_t)day_num >= days.size())
    {
        std::cerr << "Usage error: Day given was not in accepted range." << std::endl;
        return -3;
    }
    try
    {
        days[day_num]->solve(sample);
    }
    catch (const std::exception& e)
    {
        std::cerr << "Unhandled exception: " << e.what() << std::endl;
        return -4;
    }

    return 0;
}