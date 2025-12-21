
set(SRC_FILES
    src/day.cpp
    src/main.cpp
    src/days/day00.cpp
)
set(HEADER_FILES
    include/day.hpp
    include/days/day00.hpp
)

add_executable(aoc ${SRC_FILES} ${HEADER_FILES})
target_include_directories(aoc PRIVATE include/)
