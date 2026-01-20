#pragma once

namespace aoc
{
    struct Point
    {
        public:
            Point(int x, int y) noexcept;

            int x() const noexcept;
            int y() const noexcept;

            bool operator==(const Point& other) const noexcept;
            bool operator!=(const Point& other) const noexcept;

            size_t to_index(size_t width) const noexcept;

            static Point from_index(size_t index, size_t width) noexcept;
            static size_t to_index(int x, int y, size_t width) noexcept;
        private:
            int m_x;
            int m_y;
    };
}  // namespace aoc