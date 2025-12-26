#include <cstddef>
#include <exception>
#include <iostream>
#include <string>
#include <vector>

#include "day.hpp"
#include "days/day00.hpp"
#include "days/day01.hpp"
#include "days/day02.hpp"
// #include "days/day03.hpp"
// #include "days/day04.hpp"
// #include "days/day05.hpp"
// #include "days/day06.hpp"
// #include "days/day07.hpp"
// #include "days/day08.hpp"
// #include "days/day09.hpp"
// #include "days/day10.hpp"
// #include "days/day11.hpp"
// #include "days/day12.hpp"

const std::vector<aoc::DayBase*> days{
    new aoc::Day00(),
    new aoc::Day01(),
    new aoc::Day02(),
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
        days[day_num]->Solve(sample);
    }
    catch (const std::exception& e)
    {
        std::cerr << "Unhandled exception: " << e.what() << std::endl;
        return -4;
    }

    return 0;
}