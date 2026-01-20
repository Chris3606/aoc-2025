#pragma once
#include <string>
#include <vector>

#include "day.hpp"
#include "utility/grid/vector_grid_view.hpp"

namespace aoc
{
    class Day04 : public Day<std::vector<int>, std::string>
    {
        public:
            Day04();

        protected:
            virtual InputType ParseInput(std::istream& input_file) override final;
            virtual Solution1Type Part1(const InputType& input) override final;
            virtual Solution2Type Part2(const InputType& input) override final;
    };
}  // namespace aoc