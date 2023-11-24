
add_executable(TestConstrain testConstrain.cpp
                            ${CMAKE_SOURCE_DIR}/src/utility.cpp)

target_link_libraries(TestConstrain 
                        PUBLIC
                        GTest::gtest_main 
                        GTest::gmock 
                        libUtility
                        myproject::myproject_options
                        myproject::myproject_warnings
                        )
gtest_discover_tests(TestConstrain)
