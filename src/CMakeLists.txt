add_library(libUtility STATIC utility.cpp)

target_include_directories(libUtility PUBLIC 
    ${CMAKE_SOURCE_DIR}/include )

target_link_libraries(libUtility  
                    PUBLIC 
                    myproject::myproject_options
                    myproject::myproject_warnings
                    )

