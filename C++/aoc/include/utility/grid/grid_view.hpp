#pragma once
#include "utility/grid/point.hpp"

namespace aoc
{
    template <typename T>
    class IGridView
    {
        public:
            virtual ~IGridView() = default;

            virtual size_t size() const = 0;

            virtual size_t width() const = 0;
            virtual size_t height() const = 0;

            virtual T& operator[](size_t index) = 0;
            virtual const T& operator[](size_t index) const = 0;
            virtual T& operator[](int x, int y) = 0;
            virtual const T& operator[](int x, int y) const = 0;
            virtual T& operator[](const Point& point) = 0;
            virtual const T& operator[](const Point& point) const = 0;
    };
}  // namespace aoc