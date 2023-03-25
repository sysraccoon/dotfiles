cmake_minimum_required(VERSION 3.6)
project(Template)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")

set(SOURCE_FILES src/main.c)
add_executable(c-template ${SOURCE_FILES})

install (
    TARGETS c-template
    DESTINATION bin
)
