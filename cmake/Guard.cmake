#[=====================================================================================================================[

  This module prevent from in-source build.

#]=====================================================================================================================]

function(InSourceBuild)
  # get real source and binary directory
  get_filename_component(srcdir "${CMAKE_SOURCE_DIR}" REALPATH)
  get_filename_component(bindir "${CMAKE_BINARY_DIR}" REALPATH)

  # Chek in-source build
  if("${srcdir}" STREQUAL "${bindir}")
    message(WARNING "######################################################")
    message(WARNING "In-source builds are not allowed.")
    message(WARNING "Please make a new directory (called a build directory) and run CMake from there.")
    message(WARNING "######################################################")
    message(FATAL_ERROR "Quitting configuration")
  endif()

endfunction()

insourcebuild()
