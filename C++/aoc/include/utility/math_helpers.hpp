#pragma once

namespace aoc
{
    constexpr int EuclideanRemainder(int a, int b) noexcept
    {
        int result = a % b;
        return result < 0 ? result + b : result;
    }
}  // namespace aoc