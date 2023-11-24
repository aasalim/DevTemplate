include(CPM)

# Done as a function so that updates to variables like
# CMAKE_CXX_FLAGS don't propagate out to other
# targets
function(project_setup_dependencies)

  # For each dependency, see if it's
  # already been provided to us by a parent project

  # if(NOT TARGET fmtlib::fmtlib)
  #   cpmaddpackage("gh:fmtlib/fmt#9.1.0")
  # endif()
  
endfunction()