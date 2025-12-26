#pragma once
#include <iostream>
#include <vector>

namespace aoc
{
    /// @brief Overloads the stream insertion operator for std::vector.
    ///
    /// @details Outputs the vector in the format "[element1, element2, ...]".  Elements are separated by commas and
    /// spaces. Works with any type that has a defined operator<< overload.
    ///
    /// @tparam T The type of elements contained in the vector.
    ///
    /// @param os The output stream to write to.
    /// @param v The vector to be printed.
    ///
    /// @return A reference to the output stream.
    template <typename T>
    std::ostream& operator<<(std::ostream& os, const std::vector<T>& v)
    {
        os << "[";
        for (size_t i = 0; i < v.size(); ++i)
        {
            os << v[i];
            if (i != v.size() - 1)
            {
                os << ", ";
            }
        }
        os << "]";
        return os;
    }
}  // namespace aoc