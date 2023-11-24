CPMAddPackage("gh:google/googletest@1.14.0")
enable_testing()
include(GoogleTest)

add_subdirectory(unit_tests)


setup_target_for_coverage_gcovr_html(
    NAME coverage
    EXECUTABLE ctest
    DEPENDENCIES libUtility
    BASE_DIRECTORY "${CMAKE_SOURCE_DIR}"                       
    EXCLUDE "tests/" "examples/")