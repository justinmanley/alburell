find_package(GTest REQUIRED)
add_executable(Test util_test.cpp)
target_link_libraries(Test Util)
