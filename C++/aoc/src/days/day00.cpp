#include "days/day00.hpp"

#include <fstream>
#include <stdexcept>

#include "day.hpp"

namespace aoc
{
    Day00::Day00() : Day(0)
    {
    }

    Day00::InputType Day00::parse_input([[maybe_unused]] std::ifstream& input_file)
    {
        throw std::runtime_error("Input parsing not yet implemented.");
    }

    Day00::Solution1Type Day00::part1([[maybe_unused]] const InputType& input)
    {
        return "Not yet solved.";
    }

    Day00::Solution2Type Day00::part2([[maybe_unused]] const InputType& input)
    {
        return "Not yet solved.";
    }
}  // namespace aoc
