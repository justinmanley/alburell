cmake_minimum_required(VERSION 3.2)

enable_testing()

# GTest can be installed
find_package(GTest REQUIRED)
find_package(Threads REQUIRED)

include_directories(${GTEST_INCLUDE_DIRS})

# ====
# Util
# ====

add_library(Util ../src/util.cpp ../src/util.h)

add_executable(UtilTest util_test.cpp)
target_link_libraries(UtilTest Util ${GTEST_BOTH_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
target_compile_features(UtilTest PRIVATE cxx_range_for)

add_test(NAME UtilTest COMMAND Test)

