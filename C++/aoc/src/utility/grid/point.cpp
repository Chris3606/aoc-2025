#include "utility/grid/point.hpp"
#include <cstddef>

namespace aoc
{
    Point::Point(int x, int y) noexcept : m_x(x), m_y(y)
    {
    }

    int Point::x() const noexcept
    {
        return m_x;
    }

    int Point::y() const noexcept
    {
        return m_y;
    }

    bool Point::operator==(const Point& other) const noexcept
    {
        return m_x == other.m_x && m_y == other.m_y;
    }

    bool Point::operator!=(const Point& other) const noexcept
    {
        return !(*this == other);
    }

    size_t Point::to_index(size_t width) const noexcept
    {
        return Point::to_index(m_x, m_y, width);
    }

    Point Point::from_index(size_t index, size_t width) noexcept
    {
        const int x = static_cast<int>(index % width);
        const int y = static_cast<int>(index / width);
        return {x, y};
    }

    size_t Point::to_index(int x, int y, size_t width) noexcept
    {
        return static_cast<size_t>(y) * width + static_cast<size_t>(x);
    }
}  // namespace aoc