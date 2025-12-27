#include "days/day02.hpp"

#include <algorithm>
#include <istream>
#include <stdexcept>
#include <string>
#include <string_view>

#include "day.hpp"
#include "utility/parsing.hpp"
#include "utility/print_helpers.hpp"

namespace aoc
{
    Day02::Day02() : Day(2)
    {
    }

    Day02::InputType Day02::ParseInput(std::istream& input_file)
    {
        return ParseDelimited<Range<long long>>(input_file, ',');
    }

    Day02::Solution1Type Day02::Part1(const InputType& input)
    {
        long long result = 0;
        // Iterate through each number in each range
        for (const auto& range : input)
        {
            for (const auto val : range)
            {
                // We parse the numbers as strings to make it easier.  It is of course possible (and probably faster) to
                // do it mathematically, but this is sufficient and easier to reason about.
                auto s = std::to_string(val);

                // Can't have equal halves with odd length.
                if (s.size() % 2 != 0)
                    continue;

                // Otherwise, simply compare halves.
                size_t half = s.size() / 2;
                if (std::equal(s.begin(), s.begin() + half, s.begin() + half))
                    result += val;
            }
        }
        return result;
    }

    Day02::Solution2Type Day02::Part2(const InputType& input)
    {
        // Mostly same as part 1.
        long long result = 0;
        for (const auto& range : input)
        {
            for (const auto val : range)
            {
                std::string s = std::to_string(val);
                std::string_view sv(s);
                size_t half = sv.size() / 2;
                for (size_t size = 1; size <= half; ++size)
                {
                    if (sv.size() % size != 0)
                        continue;

                    // Difference, is we check substrings of all possible sizes from 1 to half of string.
                    std::string_view pattern = sv.substr(0, size);
                    bool equal = true;
                    for (size_t i = size; i < sv.size(); i += size)
                    {
                        if (sv.substr(i, size) != pattern)
                        {
                            equal = false;
                            break;
                        }
                    }
                    if (equal)
                    {
                        result += val;
                        break;
                    }
                }
            }
        }
        return result;
    }
}  // namespace aoc
