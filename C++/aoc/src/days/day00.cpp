#include "days/day00.hpp"

#include <istream>
#include <stdexcept>

#include "day.hpp"

namespace aoc
{
    Day00::Day00() : Day(0)
    {
    }

    Day00::InputType Day00::ParseInput([[maybe_unused]] std::istream& input_file)
    {
        throw std::runtime_error("Input parsing not yet implemented.");
    }

    Day00::Solution1Type Day00::Part1([[maybe_unused]] const InputType& input)
    {
        return "Not yet solved.";
    }

    Day00::Solution2Type Day00::Part2([[maybe_unused]] const InputType& input)
    {
        return "Not yet solved.";
    }
}  // namespace aoc
