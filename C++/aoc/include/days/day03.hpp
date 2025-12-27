#pragma once
#include <string>
#include <vector>

#include "day.hpp"

namespace aoc
{
    class Day03 : public Day<std::vector<std::string>, long long>
    {
        public:
            Day03();

        protected:
            virtual InputType ParseInput(std::istream& input_file) override final;
            virtual Solution1Type Part1(const InputType& input) override final;
            virtual Solution2Type Part2(const InputType& input) override final;

        private:
            static size_t IndexOfMaxDigit(const std::string_view& str);
            static long long GetNumber(int num_digits, const std::string& battery_bank);
    };
}  // namespace aoc