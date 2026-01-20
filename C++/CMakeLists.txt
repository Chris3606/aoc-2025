cmake_minimum_required(VERSION 3.15)

project(aoc-2025 VERSION 1.0.0 LANGUAGES C CXX)

######## Options ########
# Compatible with MSVC so code can be cross-platform
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSION OFF)

# Cross-platform settings (TODO: Implement later)
option(ENABLE_LTO "Whether or not to enable link-time optimization for release modes." ON)
option(ENABLE_ANALYZERS "Whether or not to enable various analyzers for compilation (/analyze for MSVC, -Wpedantic and etc on nix)." ON)
option(OPTIMIZE_RELEASE_FOR_SIZE "Whether or not to optimize Release for size." ON)
option(ENABLE_ASAN "Whether or not to enable the address sanitizer." ON)

add_subdirectory(aoc)