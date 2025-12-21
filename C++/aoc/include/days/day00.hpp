#pragma once
#include <string>
#include <vector>

#include "day.hpp"

namespace aoc
{
    class Day00 : public Day<std::vector<int>, std::string>
    {
        public:
            Day00();

        protected:
            virtual InputType parse_input(std::ifstream& input_file) override final;
            virtual Solution1Type part1(const InputType& input) override final;
            virtual Solution2Type part2(const InputType& input) override final;
    };
}  // namespace aoc