# `cmake/`

## Purpose

Directory contains CMake-specific files and scripts that are used to configure the build process.

## Notes

This directory is not required.

In a C++ CMake project, the `cmake` directory typically contains CMake-specific files and scripts used to configure the build process. This may include `FindXXX.cmake` or `XXXConfig.cmake` files to assist in locating external libraries, a `Modules` directory with additional CMake modules or scripts, and a toolchain file for specifying cross-compilation settings. These files and scripts help customize the build configuration, manage dependencies, and extend the capabilities of the CMake build system.