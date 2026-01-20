#include "days/day03.hpp"

#include <algorithm>
#include <istream>
#include <numeric>
#include <string>
#include <string_view>

#include "day.hpp"
#include "utility/parsing.hpp"

namespace aoc
{
    Day03::Day03() : Day(3)
    {
    }

    Day03::InputType Day03::ParseInput(std::istream& input_file)
    {
        return ParseLines<std::string>(input_file);
    }

    Day03::Solution1Type Day03::Part1(const InputType& input)
    {
        return OptimizeBatteries(input, 2);
    }

    Day03::Solution2Type Day03::Part2(const InputType& input)
    {
        return OptimizeBatteries(input, 12);
    }

    long long Day03::OptimizeBatteries(const InputType& input, int num_digits)
    {
        return std::accumulate(input.begin(),
                               input.end(),
                               0LL,
                               [num_digits](long long acc, const std::string& battery)
                               { return acc + Day03::GetNumber(num_digits, battery); });
    }

    long long Day03::GetNumber(int num_digits, const std::string& battery_bank)
    {
        std::string_view remaining(battery_bank);

        // Find highest digit, leaving at least enough digits to ensure we get enough.  By definition, we must have
        // exactly the given number of digits (no less); a) because the problem stated we needed _exactly_ x digits, and
        // b) because by defition a positive number with n arbitrary digits is bigger than a number with n - 1 digits,
        // for any n >= 2.
        //
        // This is a fancy way to say, 19 is bigger than 9.
        std::string selected_digits;

        for (int x = 0; x < num_digits; ++x)
        {
            // Whatever we select, it has to leave at least this many digits left for the next iteration (minus 1), to
            // ensure we have enough digits to get to the proper number
            const int num_digits_remaining = num_digits - x;
            auto eligible_digits = remaining.substr(0, (remaining.size() - num_digits_remaining) + 1);

            // Find the max digit and add it to our string
            const size_t max_digit_idx = Day03::IndexOfMaxDigit(eligible_digits);
            selected_digits.push_back(remaining[max_digit_idx]);

            // The next digit has to be after the current one, so shrink the remaining pool.
            remaining = remaining.substr(max_digit_idx + 1);
        }

        // Now just convert string to a number and return it.
        return std::stoll(selected_digits);
    }

    size_t Day03::IndexOfMaxDigit(const std::string_view& str)
    {
        auto max_it = std::max_element(str.begin(), str.end());
        return std::distance(str.begin(), max_it);
    }
}  // namespace aoc
