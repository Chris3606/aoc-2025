#pragma once
#include <concepts>
#include <ranges>
#include <type_traits>

namespace aoc
{
    /// @brief A template struct representing an inclusive range of integral values
    ///
    /// @tparam T An integral type (satisfies std::integral concept)
    ///
    /// @details Range represents a closed interval [start, end] of integral values. It provides views and iteration
    /// support for the range of values from start to end (inclusive). The range is considered empty if start > end.
    template <std::integral T>
    struct Range
    {
            /// @brief The starting value of the range (inclusive)
            T min;

            /// @brief The ending value of the range (inclusive)
            T max;

            /// @brief Default constructor
            constexpr Range() = default;

            /// @brief Constructs a Range with given start and end values
            ///
            /// @param a The start value of the range (inclusive)
            /// @param b The end value of the range (inclusive)
            constexpr Range(T a, T b) : min(a), max(b)
            {
            }

            /// @brief Checks if the range is empty
            ///
            /// @return true if start > end, false otherwise
            constexpr bool empty() const noexcept
            {
                return min > max;
            }

            /// @brief Returns a C++20 view of the inclusive range
            ///
            /// @return A std::ranges::iota_view representing [min, max] inclusive
            ///
            /// @note Avoid using with max == std::numeric_limits<T>::max() as the view increments max+1 for the
            /// sentinel value
            auto as_view() const
            {
                if (empty())
                    return std::views::iota(min, max);  // empty iota_view
                return std::views::iota(min, static_cast<T>(max + 1));
            }

            /// @brief Returns an iterator to the beginning of the range
            auto begin() const
            {
                return as_view().begin();
            }

            /// @brief Returns an iterator to the end of the range
            auto end() const
            {
                return as_view().end();
            }

            /// @brief  Parses a Range from an input stream in the format "a-b"
            friend std::istream& operator>>(std::istream& is, Range& range)
            {
                char dash = '\0';
                T a = 0;
                T b = 0;

                if (!(is >> a))
                {
                    is.setstate(std::ios::failbit);
                    return is;
                }

                if (!(is >> dash) || dash != '-')
                {
                    is.setstate(std::ios::failbit);
                    return is;
                }

                if (!(is >> b))
                {
                    is.setstate(std::ios::failbit);
                    return is;
                }

                range.min = a;
                range.max = b;
                return is;
            }

            /// @brief Outputs the Range to an output stream in the format "a-b"
            friend std::ostream& operator<<(std::ostream& os, const Range& range)
            {
                os << range.min << "-" << range.max;
                return os;
            }
    };

    /// @brief Deduction guide for Range constructor
    ///
    /// Allows the Range class template to deduce its template parameter type from the types of two integral arguments
    /// passed to the constructor.
    ///
    /// @tparam T An integral type (satisfies std::integral concept)
    ///
    /// @details When constructing a Range with two integral arguments of the same type, this deduction guide ensures
    /// the Range is instantiated with the correct integral type without requiring explicit template arguments.
    ///
    /// @example
    /// Range r(0, 10);        // Deduces as Range<int>
    /// Range r(0u, 10u);      // Deduces as Range<unsigned int>
    /// Range r(0LL, 10LL);    // Deduces as Range<long long>
    template <std::integral T>
    Range(T, T) -> Range<T>;

}  // namespace aoc