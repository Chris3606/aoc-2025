#pragma once
#include <string>
#include <vector>

#include "day.hpp"
#include "utility/range.hpp"

namespace aoc
{
    class Day02 : public Day<std::vector<Range<long long>>, long long>
    {
        public:
            Day02();

        protected:
            virtual InputType ParseInput(std::istream& input_file) override final;
            virtual Solution1Type Part1(const InputType& input) override final;
            virtual Solution2Type Part2(const InputType& input) override final;
    };
}  // namespace aoc