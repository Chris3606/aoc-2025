
set(SRC_FILES
    src/day.cpp
    src/main.cpp
    src/days/day00.cpp
    src/days/day01.cpp
    src/utility/math_helpers.cpp
)
set(HEADER_FILES
    include/day.hpp
    include/days/day00.hpp
    include/days/day01.hpp
    include/utility/math_helpers.hpp
    include/utility/parsing.hpp
)

add_executable(aoc ${SRC_FILES} ${HEADER_FILES})
target_include_directories(aoc PRIVATE include/)

target_compile_options(aoc PRIVATE /W4 /WX /permissive-)
