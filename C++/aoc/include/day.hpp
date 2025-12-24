#pragma once
#include <fstream>
#include <iostream>
#include <istream>

namespace aoc
{
    class DayBase
    {
        public:
            DayBase(int day);

            virtual void Solve(bool sample);

        protected:
            virtual void ParseAndProcess(std::istream& input_file) = 0;

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

            void ParseAndProcess(std::istream& input_file) override final
            {
                auto input = ParseInput(input_file);

                auto p1 = Part1(input);
                std::cout << "Part 1: " << p1 << std::endl;

                auto p2 = Part2(input);
                std::cout << "Part 2: " << p2 << std::endl;
            }

            virtual InputType ParseInput(std::istream& input_file) = 0;
            virtual Solution1Type Part1(const InputType& input) = 0;
            virtual Solution2Type Part2(const InputType& input) = 0;
    };
}  // namespace aoc