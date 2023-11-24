include(CMakeDependentOption)

macro(project_supports_sanitizers)
  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND NOT WIN32)
    set(SUPPORTS_UBSAN ON)
  else()
    set(SUPPORTS_UBSAN OFF)
  endif()

  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND WIN32)
    set(SUPPORTS_ASAN OFF)
  else()
    set(SUPPORTS_ASAN ON)
  endif()
endmacro()

macro(project_setup_options)
    option(project_ENABLE_HARDENING "Enable hardening" OFF)
    option(project_ENABLE_COVERAGE "Enable coverage reporting" ${BUILD_TESTING})

    cmake_dependent_option(
        project_ENABLE_GLOBAL_HARDENING
        "Attempt to push hardening options to built dependencies"
        ON
        project_ENABLE_HARDENING
        OFF)

    project_supports_sanitizers()

    if(NOT PROJECT_IS_TOP_LEVEL OR project_PACKAGING_MAINTAINER_MODE)
        option(project_ENABLE_IPO "Enable IPO/LTO" ON)
        option(project_WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)
        option(project_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
        option(project_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ON)
        option(project_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" ON)
        option(project_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ON)
        option(project_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
        option(project_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" ON)
        option(project_ENABLE_UNITY_BUILD "Enable unity builds" ON)
        option(project_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
        option(project_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
        option(project_ENABLE_PCH "Enable precompiled headers" ON)
        option(project_ENABLE_CACHE "Enable ccache" ON)
    else()
        option(project_ENABLE_IPO "Enable IPO/LTO" ON)
        option(project_WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)
        option(project_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
        option(project_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN})
        option(project_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" ON)
        option(project_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN})
        option(project_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
        option(project_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" ON)
        option(project_ENABLE_UNITY_BUILD "Enable unity builds" ON)
        option(project_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
        option(project_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
        option(project_ENABLE_PCH "Enable precompiled headers" ON)
        option(project_ENABLE_CACHE "Enable ccache" ON)
    endif()
    if(NOT PROJECT_IS_TOP_LEVEL)
        mark_as_advanced(
            project_ENABLE_IPO
            project_WARNINGS_AS_ERRORS
            project_ENABLE_USER_LINKER
            project_ENABLE_SANITIZER_ADDRESS
            project_ENABLE_SANITIZER_LEAK
            project_ENABLE_SANITIZER_UNDEFINED
            project_ENABLE_SANITIZER_THREAD
            project_ENABLE_SANITIZER_MEMORY
            project_ENABLE_UNITY_BUILD
            project_ENABLE_CLANG_TIDY
            project_ENABLE_CPPCHECK
            project_ENABLE_COVERAGE
            project_ENABLE_PCH
            project_ENABLE_CACHE)
    endif()
endmacro()

macro(project_global_options)
    if(project_ENABLE_IPO)
        include(CheckIPOSupported)
        check_ipo_supported(RESULT result OUTPUT output)
        if(result)
            set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
            message(STATUS "IPO is enabled.")
        else()
            message(SEND_ERROR "IPO is not supported: ${output}")
        endif()
    endif()
    
    project_supports_sanitizers()
    
    if(project_ENABLE_HARDENING AND project_ENABLE_GLOBAL_HARDENING)
        include(Hardening)
        if(NOT SUPPORTS_UBSAN 
            OR project_ENABLE_SANITIZER_UNDEFINED
            OR project_ENABLE_SANITIZER_ADDRESS
            OR project_ENABLE_SANITIZER_THREAD
            OR project_ENABLE_SANITIZER_LEAK)
            set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
        else()
            set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
        endif()
        message(STATUS "Hardening is ${project_ENABLE_HARDENING}.")
        message(STATUS "UBSAN Minimal Runtime is ${ENABLE_UBSAN_MINIMAL_RUNTIME}.")
        message(STATUS "Sanitizer Undefined is ${project_ENABLE_SANITIZER_UNDEFINED}.")
        project_enable_hardening(project_options ON ${ENABLE_UBSAN_MINIMAL_RUNTIME})
    endif()
endmacro()

macro(project_local_options)
    if(PROJECT_IS_TOP_LEVEL)
        include(StandardProjectSettings)
    endif()

    # Interface libraries to propagate options
    include(CompilerWarnings)
    add_library(project_warnings INTERFACE)
    add_library(project_options INTERFACE)
    project_set_project_warnings(
        project_warnings
        ${project_WARNINGS_AS_ERRORS}
        ""
        ""
        ""
        "")

    if(project_ENABLE_USER_LINKER)
        include(Linker)
        project_configure_linker(project_options)
    endif()
    
    include(Sanitizers)
    project_enable_sanitizers(
        project_options
        ${project_ENABLE_SANITIZER_ADDRESS}
        ${project_ENABLE_SANITIZER_LEAK}
        ${project_ENABLE_SANITIZER_UNDEFINED}
        ${project_ENABLE_SANITIZER_THREAD}
        ${project_ENABLE_SANITIZER_MEMORY})

    set_target_properties(project_options PROPERTIES UNITY_BUILD ${project_ENABLE_UNITY_BUILD})
    
    # Enable Pre-compiled Headers
    if(project_ENABLE_PCH)
        target_precompile_headers(
            project_options
            INTERFACE
            <vector>
            <string>
            <utility>)
    endif()

    # Enable Compiler Cache tool
    if(project_ENABLE_CACHE)
        include(Cache)
        project_enable_cache()
    endif()

    # Static Analyzers
    include(StaticAnalyzers)

    # Enable Clang-Tidy 
    if(project_ENABLE_CLANG_TIDY)
        project_enable_clang_tidy(project_options ${project_WARNINGS_AS_ERRORS})
    endif()

    # Enable Cppcheck
    if(project_ENABLE_CPPCHECK)
        project_enable_cppcheck(${project_WARNINGS_AS_ERRORS} "" # override cppcheck options
        )
    endif()

    # Enable Coverage
    if(project_ENABLE_COVERAGE)
        include(CodeCoverage)
        set(GCOVR_ADDITIONAL_ARGS "--decisions" "-s")
        target_compile_options(project_options INTERFACE -O0 )
        target_link_libraries(project_options INTERFACE)
        append_coverage_compiler_flags()
    endif()

    # Enable warnings as errors
    if(project_WARNINGS_AS_ERRORS)
        include(CheckCXXCompilerFlag)
        CHECK_CXX_COMPILER_FLAG ("-Wl,--fatal-warnings" LINKER_FATAL_WARNINGS)
        if(LINKER_FATAL_WARNINGS)
            # This is not working consistently, so disabling for now
            # target_link_options(project_options INTERFACE -Wl,--fatal-warnings)
        endif()
    endif()

    # Enable hardening
    if(project_ENABLE_HARDENING AND NOT project_ENABLE_GLOBAL_HARDENING)
        include(Hardening)
        if(NOT SUPPORTS_UBSAN 
            OR project_ENABLE_SANITIZER_UNDEFINED
            OR project_ENABLE_SANITIZER_ADDRESS
            OR project_ENABLE_SANITIZER_THREAD
            OR project_ENABLE_SANITIZER_LEAK)
            set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
        else()
            set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
        endif()
        project_enable_hardening(project_options OFF ${ENABLE_UBSAN_MINIMAL_RUNTIME})
    endif()
endmacro()