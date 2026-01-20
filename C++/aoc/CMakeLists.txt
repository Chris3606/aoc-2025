
set(SRC_FILES
    src/day.cpp
    src/main.cpp
    src/days/day00.cpp
    src/days/day01.cpp
    src/days/day02.cpp
    src/days/day03.cpp
    src/days/day04.cpp
    src/utility/math_helpers.cpp
    src/utility/grid/grid_view.cpp
    src/utility/grid/point.cpp
    src/utility/grid/direction.cpp
)
set(HEADER_FILES
    include/day.hpp
    include/days/day00.hpp
    include/days/day01.hpp
    include/days/day02.hpp
    include/days/day03.hpp
    include/days/day04.hpp
    include/utility/math_helpers.hpp
    include/utility/parsing.hpp
    include/utility/range.hpp
    include/utility/print_helpers.hpp
    include/utility/grid/grid_view.hpp
    include/utility/grid/vector_grid_view.hpp
    include/utility/grid/point.hpp
    include/utility/grid/direction.hpp
)

add_executable(aoc ${SRC_FILES} ${HEADER_FILES})
target_include_directories(aoc PRIVATE include/)

target_compile_options(aoc PRIVATE /W4 /WX /permissive-)
