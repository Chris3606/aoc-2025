#pragma once
#include <istream>
#include <string>
#include <vector>

#include "day.hpp"

namespace aoc
{
    enum class InstructionDirection
    {
        Left,
        Right
    };

    class Instruction
    {
        public:
            Instruction() noexcept;
            Instruction(InstructionDirection direction, int clicks) noexcept;
            friend std::istream& operator>>(std::istream& is, Instruction& instr);

            InstructionDirection Direction() const noexcept;
            int Clicks() const noexcept;

        private:
            InstructionDirection m_direction;
            int m_clicks;
    };

    std::istream& operator>>(std::istream& is, Instruction& instr);

    class Day01 : public Day<std::vector<Instruction>, int>
    {
        public:
            Day01();

        protected:
            virtual InputType ParseInput(std::istream& input_file) override final;
            virtual Solution1Type Part1(const InputType& input) override final;
            virtual Solution2Type Part2(const InputType& input) override final;
    };
}  // namespace aoc