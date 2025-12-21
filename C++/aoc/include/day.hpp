#pragma once
#include <fstream>
#include <iostream>

namespace aoc
{
    class DayBase
    {
        public:
            DayBase(int day);

            virtual void solve(bool sample);

        protected:
            virtual void parse_and_process(std::ifstream& input_file) = 0;

        private:
            int m_day;
    };

    template <typename TInput, typename TSolution1, typename TSolution2 = TSolution1>
    class Day : public DayBase
    {
        public:
            using DayBase::DayBase;

            using InputType = TInput;
            using Solution1Type = TSolution1;
            using Solution2Type = TSolution2;

            void parse_and_process(std::ifstream& input_file) override final
            {
                auto input = parse_input(input_file);
                input_file.close();

                auto p1 = part1(input);
                std::cout << "Part 1: " << p1 << std::endl;

                auto p2 = part2(input);
                std::cout << "Part 2: " << p2 << std::endl;
            }

            virtual InputType parse_input(std::ifstream& input_file) = 0;
            virtual Solution1Type part1(const InputType& input) = 0;
            virtual Solution2Type part2(const InputType& input) = 0;
    };
}  // namespace aoc