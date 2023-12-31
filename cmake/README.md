# `cmake/`

## Purpose

Directory contains CMake-specific files and scripts that are used to configure the build process.

## Notes

This directory is not required.

In a C++ CMake project, the `cmake` directory typically contains CMake-specific files and scripts used to configure the build process. This may include `FindXXX.cmake` or `XXXConfig.cmake` files to assist in locating external libraries, a `Modules` directory with additional CMake modules or scripts, and a toolchain file for specifying cross-compilation settings. These files and scripts help customize the build configuration, manage dependencies, and extend the capabilities of the CMake build system.

| cmake script   | Purpose                                                      |
| -------------- | ------------------------------------------------------------ |
| ***Cache***    | `project_enable_cache` Enables a compiler cache tool that is designed to speed up the compilation.|
| ***Colors***   | Defines colors and allows the `message` function to print with colors|
| ***CodeCoverage***   | `project_enable_coverage` enable code coverage compiler and linker flags |
| ***CompilerWarnings***| `project_set_project_warnings` function to apply warnings for varies compilers on a project. |
| ***CPM***      |CMake dependency management tool. Used to retrieve packages.|
| ***Dependencies*** |Retrieve project dependencies using CPM|
| ***Hardening***| `project_enable_hardening` checks if the compiler is compatiable with some hardening features and provides possible options to add for compiler and linker.                         |
| ***Linker***   | `project_configure_linker` configures linker flags |
| ***ProjectOptions***| `project_setup_options`, `project_global_options` provides setup options and allows for tuning project global and local options                          |
| ***Sanitizers***| `project_enable_sanitizers` configure sanitizers to be enabled. Address, Leak, Undefined Behavior, Thread, and Memory sanitizers. |
| ***StandardProjectSettings*** |Sets up configuration and build types. *ex:* Debug or Release|
| ***StaticAnalyzers*** | `project_enable_cppcheck`, `project_enable_clang_tidy` enables different static analyzers.|