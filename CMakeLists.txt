cmake_minimum_required(VERSION 3.21)
project(ProjectName)

# Set C++ Standard
if (NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 11)
endif()

# Verbose makefile
set(CMAKE_VERBOSE_MAKEFILE ON)

# Add the 'cmake' directory to the CMAKE_MODULE_PATH
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Add color variables and output message function with colors
include(Colors)

# Add project options utility
include(ProjectOptions)

# Project Setup Options
project_setup_options()

# Global Options
project_global_options()

# Retrieve Project Dependencies
include(Dependencies)
# Setup Project Dependencies
project_setup_dependencies()

# Local Options
project_local_options()

set(CMAKE_CXX_VISIBILITY_PRESET hidden)

target_compile_features(project_options INTERFACE cxx_std_${CMAKE_CXX_STANDARD})

add_library(ProjectName::project_options ALIAS project_options)
add_library(ProjectName::project_warnings ALIAS project_warnings)

configure_file(Version.h.in Version.h @ONLY)

add_subdirectory(src)
if(BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()

# Don't even look at tests if we're not top level
if(NOT PROJECT_IS_TOP_LEVEL)
  return()
endif()

if(BUILD_TESTING)
    include(CTest)
    add_subdirectory(tests)
endif()
