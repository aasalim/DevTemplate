cmake_minimum_required(VERSION 3.16.3)
project(Project)

# Add the 'cmake' directory to the CMAKE_MODULE_PATH
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
# Add color variable and output message function with colors
include(Colors)
# Add standard project settings
include(StandardProjectSettings)

add_subdirectory(examples)