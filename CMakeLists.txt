cmake_minimum_required(VERSION 3.2)

# See queezythegreat/arduino-cmake#146.
# Set so that CMake recognizes the uno board, per blemasle/arduino-cmake.
set(ARDUINO_1_5 TRUE)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/arduino-cmake/cmake/ArduinoToolchain.cmake)

set(PROJECT_NAME Alburrell)
project(${PROJECT_NAME})

# ==============
# Arduino sketch
# ==============

add_subdirectory(src)

generate_arduino_firmware(Sketch
    BOARD uno 
    SKETCH ${CMAKE_SOURCE_DIR}/studies/simple
    PORT /dev/ttyACM0
    LIBS Util)

