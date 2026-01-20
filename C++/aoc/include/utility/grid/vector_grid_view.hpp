#pragma once
#include <stdexcept>
#include <vector>

#include "utility/grid/grid_view.hpp"
#include "utility/grid/point.hpp"

namespace aoc
{
    template <typename T>
    class VectorGridView : public IGridView<T>
    {
        public:
            VectorGridView(size_t width, size_t height) noexcept
                : m_data(width * height), m_width(width), m_height(height) {};

            VectorGridView(std::vector<T>& data, size_t width)
                : m_data(data), m_width(width), m_height(data.size() / width)
            {
                if (data.size() % width != 0)
                    throw std::invalid_argument("Data size is not a multiple of width (aka contains incomplete rows).");
            };

            virtual size_t size() const override
            {
                return m_data.size();
            };

            virtual size_t width() const override
            {
                return m_width;
            };

            virtual size_t height() const override
            {
                return m_height;
            };

            virtual T& operator[](size_t index) override
            {
                return m_data[index];
            };

            virtual const T& operator[](size_t index) const override
            {
                return m_data[index];
            };

            virtual T& operator[](int x, int y) override
            {
                return m_data[Point::to_index(x, y, m_width)];
            };

            virtual const T& operator[](int x, int y) const override
            {
                return m_data[Point::to_index(x, y, m_width)];
            };

            virtual T& operator[](const Point& point) override
            {
                return m_data[point.to_index(m_width)];
            };

            virtual const T& operator[](const Point& point) const override
            {
                return m_data[point.to_index(m_width)];
            };

        private:
            std::vector<T> m_data;
            size_t m_width;
            size_t m_height;
    };
}  // namespace aoc