cmake_minimum_required(VERSION 3.21)
project(myproject)

# Set C++ Standard
if (NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 11)
endif()

# Verbose makefile
set(CMAKE_VERBOSE_MAKEFILE OFF)

# Add the 'cmake' directory to the CMAKE_MODULE_PATH
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Add color variables and output message function with colors
include(Colors)

# Add project options utility
include(ProjectOptions)

# Project Setup Options
myproject_setup_options()

# Global Options
myproject_global_options()

# Retrieve Project Dependencies
include(Dependencies)
# Setup Project Dependencies
# myproject_setup_dependencies()

# Local Options
myproject_local_options()

set(CMAKE_CXX_VISIBILITY_PRESET hidden)

target_compile_features(myproject_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})

add_library(myproject::myproject_options ALIAS myproject_options)
add_library(myproject::myproject_warnings ALIAS myproject_warnings)

configure_file(Version.h.in Version.h @ONLY)

add_subdirectory(src)
add_subdirectory(examples)

# Don't even look at tests if we're not top level
if(NOT PROJECT_IS_TOP_LEVEL)
  return()
endif()

# Adding the tests:
include(CTest)

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
