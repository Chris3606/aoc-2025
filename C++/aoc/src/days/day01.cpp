#include "days/day01.hpp"

#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "day.hpp"
#include "utility/math_helpers.hpp"
#include "utility/parsing.hpp"

namespace aoc
{
    std::istream& operator>>(std::istream& is, Instruction& instr)
    {
        char dir = '\0';
        int clicks = 0;

        if (!(is >> dir))
        {
            is.setstate(std::ios::failbit);
            return is;
        }

        if (!(is >> clicks))
        {
            is.setstate(std::ios::failbit);
            return is;
        }

        switch (dir)
        {
            case 'L':
                instr.m_direction = InstructionDirection::Left;
                break;
            case 'R':
                instr.m_direction = InstructionDirection::Right;
                break;
            default:
                is.setstate(std::ios::failbit);
                return is;
        }

        instr.m_clicks = clicks;
        return is;
    }

    Instruction::Instruction() noexcept : m_direction(InstructionDirection::Left), m_clicks(0)
    {
    }

    Instruction::Instruction(InstructionDirection direction, int clicks) noexcept
        : m_direction(direction), m_clicks(clicks)
    {
    }

    InstructionDirection Instruction::Direction() const noexcept
    {
        return m_direction;
    }

    int Instruction::Clicks() const noexcept
    {
        return m_clicks;
    }

    Day01::Day01() : Day(1)
    {
    }

    Day01::InputType Day01::ParseInput([[maybe_unused]] std::istream& input_file)
    {
        return ParseLines<Instruction>(input_file);
    }

    Day01::Solution1Type Day01::Part1(const InputType& input)
    {
        int current_position = 50;

        int times_zero = 0;
        // Use euclidean remainder to wrap around the circular track, ensuring that negative positions are handled
        // correctly.
        for (const auto& instr : input)
        {
            const int abs_clicks = instr.Direction() == InstructionDirection::Left ? -instr.Clicks() : instr.Clicks();
            current_position = aoc::EuclideanRemainder(current_position + abs_clicks, 100);
            if (current_position == 0)
                ++times_zero;
        }
        return times_zero;
    }

    Day01::Solution2Type Day01::Part2([[maybe_unused]] const InputType& input)
    {
        int current_position = 50;

        int times_zero = 0;

        for (const auto& instr : input)
        {
            // Count number of full rotations, each of which by definition passes 0 exactly once.
            times_zero += instr.Clicks() / 100;

            // Update current value
            const int abs_clicks = instr.Direction() == InstructionDirection::Left ? -instr.Clicks() : instr.Clicks();
            const int old_position = current_position;
            current_position = EuclideanRemainder(current_position + abs_clicks, 100);

            // Find if we passed 0 during the remaining wrap.  We ignore if we're _on_ zero; that's captured later.
            if (old_position != 0 && current_position != 0)
            {
                if ((abs_clicks < 0 && current_position > old_position) ||
                    (abs_clicks > 0 && current_position < old_position))
                    times_zero += 1;  // In this case we have wrapped around during the uncounted, <100 turn
            }

            if (current_position == 0)
                ++times_zero;
        }
        return times_zero;
    }

}  // namespace aoc
