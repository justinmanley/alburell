cmake_minimum_required(VERSION 3.2)

set(PROJECT_NAME Alburrell)
project(${PROJECT_NAME})

# This adds another subdirectory, which has 'project(gtest)'.
add_subdirectory(lib/gtest-1.7.0)

enable_testing()

# Include the gtest library. gtest_SOURCE_DIR is available due to
# 'project(gtest)' above.
include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})

add_executable(Test util_test.cpp)

add_library(Util util.cpp util.h)

# target_compile_features(Test PRIVATE cxx_range_for)
set_property(TARGET Test PROPERTY CXX_STANDARD 11)
target_link_libraries(Test Util gtest gtest_main)

add_test(Name UtilTest COMMAND Test)
