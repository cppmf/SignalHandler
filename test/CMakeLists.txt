# -------------------------------------------------------------------------------------------------------------------- #
#
# Copyright (c) 2021 C++ Modern Framework
#
# -------------------------------------------------------------------------------------------------------------------- #
cmake_minimum_required(VERSION 3.21 FATAL_ERROR)

#
set(ROOT_PROJECT SignalHandler)

# -------------------------------------------------------------------------------------------------------------------- #
# Early includes
# -------------------------------------------------------------------------------------------------------------------- #
include(../cmake/Guard.cmake)
include(../cmake/CPM.cmake)

# -------------------------------------------------------------------------------------------------------------------- #
# Add project dependencies
#
# Some dependencies are added using CPM see https://github.com/TheLartians/CPM.cmake for more info.
# -------------------------------------------------------------------------------------------------------------------- #
CPMAddPackage(
  NAME ${ROOT_PROJECT}
  SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/..
  OPTIONS "SH_INSTALL YES"
)
CPMAddPackage("gh:catchorg/Catch2@2.13.7")

# -------------------------------------------------------------------------------------------------------------------- #
# Project configuration
# -------------------------------------------------------------------------------------------------------------------- #
project(${ROOT_PROJECT}_Test LANGUAGES CXX)

# -------------------------------------------------------------------------------------------------------------------- #
# Options
# -------------------------------------------------------------------------------------------------------------------- #
option(ENABLE_CODE_COVERAGE "Enable code coverage" OFF)

# -------------------------------------------------------------------------------------------------------------------- #
# Create binary
# -------------------------------------------------------------------------------------------------------------------- #
add_executable(${PROJECT_NAME} main.cpp SignalHandler.cpp)

# Properties by creating the executable in the bin folder, this ensure running the app on Windows
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Compile options
include(../cmake/Warnings.cmake)
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_17)
target_compile_warnings(${PROJECT_NAME})

# Dependencies
target_link_libraries(${PROJECT_NAME} PUBLIC ${ROOT_PROJECT})
target_link_libraries(${PROJECT_NAME} PRIVATE Catch2::Catch2)

# -------------------------------------------------------------------------------------------------------------------- #
# Test
# -------------------------------------------------------------------------------------------------------------------- #
enable_testing()
add_test(NAME ${PROJECT_NAME} COMMAND ${PROJECT_NAME})

# -------------------------------------------------------------------------------------------------------------------- #
# Code coverage
# -------------------------------------------------------------------------------------------------------------------- #
if(ENABLE_CODE_COVERAGE)
  # Get CodeCoverage.cmake from bilke/cmake-modules
  file(DOWNLOAD https://raw.githubusercontent.com/bilke/cmake-modules/master/CodeCoverage.cmake
       ${CMAKE_BINARY_DIR}/cmake/CodeCoverage.cmake
  )
  include(${CMAKE_BINARY_DIR}/cmake/CodeCoverage.cmake)
  #
  separate_arguments(COVERAGE_COMPILER_FLAGS)
  # Set coverage compiler flags
  target_compile_options(${ROOT_PROJECT} PUBLIC -O0 ${COVERAGE_COMPILER_FLAGS})
  target_link_options(${ROOT_PROJECT} PUBLIC ${COVERAGE_COMPILER_FLAGS})
endif()
