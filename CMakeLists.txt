# -------------------------------------------------------------------------------------------------------------------- #
#
# Copyright (c) 2021 C++ Modern Framework
#
# -------------------------------------------------------------------------------------------------------------------- #
cmake_minimum_required(VERSION 3.21 FATAL_ERROR)

# -------------------------------------------------------------------------------------------------------------------- #
# Early includes
# -------------------------------------------------------------------------------------------------------------------- #
include(cmake/Guard.cmake) # Prevent in-source build
include(cmake/CPM.cmake) # Add CPM package manager

# -------------------------------------------------------------------------------------------------------------------- #
# Add project dependencies
#
# Some dependencies are added using CPM see https://github.com/TheLartians/CPM.cmake for more info.
# -------------------------------------------------------------------------------------------------------------------- #
CPMAddPackage(
  NAME ProjectMeta.cmake
  GIT_TAG 1.2.2
  GITHUB_REPOSITORY cppmf/ProjectMeta.cmake
)

# -------------------------------------------------------------------------------------------------------------------- #
# Project information
# -------------------------------------------------------------------------------------------------------------------- #
ProjectMeta(
  PROJECT_ID SH
  PROJECT_NAMESPACE SH
  PROJECT_NAME SignalHandler
  PROJECT_DESCRIPTION "TODO"
  PROJECT_COPYRIGHT "© 2021 C++ Modern Framework"
  PROJECT_URL "https://github.com/cppmf/SignalHandler"
  VERSION_MAJOR 0
  VERSION_MINOR 0
  VERSION_PATCH 1
  AUTHOR_ORGANIZATION "C++ Modern Framework"
  AUTHOR_DOMAIN "https://github.com/cppmf"
  AUTHOR_MAINTAINER "CppMF Team"
)

# -------------------------------------------------------------------------------------------------------------------- #
# Project configuration
# -------------------------------------------------------------------------------------------------------------------- #
project(
  ${${PROJECT_ID}_PROJECT_NAME}
  VERSION ${${PROJECT_ID}_VERSION}
  DESCRIPTION ${${PROJECT_ID}_PROJECT_DESCRIPTION}
  LANGUAGES CXX
)

# -------------------------------------------------------------------------------------------------------------------- #
# Options
# -------------------------------------------------------------------------------------------------------------------- #
# Install: the install rule is set to YES if this is a master project
option(${PROJECT_ID}_INSTALL "Generate the install target ofr ${PROJECT_NAME}" "${PROJECT_IS_TOP_LEVEL}")

# -------------------------------------------------------------------------------------------------------------------- #
# C++ configuration
# -------------------------------------------------------------------------------------------------------------------- #

# Prevent shared library to export unintended symbols
if(NOT DEFINED CMAKE_CXX_VISIBILITY_PRESET AND NOT DEFINED CMAKE_VISIBILITY_INLINES_HIDDEN)
  set(CMAKE_CXX_VISIBILITY_PRESET hidden)
  set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)
endif()

# Override BUILD_SHARED_LIBS
if(DEFINED ${PROJECT_NAME}_SHARED_LIBS)
  set(BUILD_SHARED_LIBS "${${PROJECT_NAME}_SHARED_LIBS}")
endif()

# -------------------------------------------------------------------------------------------------------------------- #
# Create the main library target
# -------------------------------------------------------------------------------------------------------------------- #

# Create the library target and its alias (sources files are added using target_sources)
add_library(${PROJECT_NAME} "")
add_library(${PROJECT_NAMESPACE}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# Define source files for the library
include(CMakeLists_files.cmake)
target_sources(
  ${PROJECT_NAME}
  PUBLIC $<BUILD_INTERFACE:${HEADERS}>
  PRIVATE ${SOURCES}
)

# Properties
include(cmake/Project-postfix.cmake)
set_target_properties(${PROJECT_NAME} PROPERTIES VERSION "${${PROJECT_NAME}_VERSION}")
set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION "${${PROJECT_NAME}_VERSION_MAJOR}")
set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "${${PROJECT_NAME}_DEBUG_POSTFIX}")
set_target_properties(${PROJECT_NAME} PROPERTIES RELEASE_POSTFIX "${${PROJECT_NAME}_RELEASE_POSTFIX}")
set_target_properties(${PROJECT_NAME} PROPERTIES RELWITHDEBINFO_POSTFIX "${${PROJECT_NAME}_RELEASE_POSTFIX}")
set_target_properties(${PROJECT_NAME} PROPERTIES RELEASE_POSTFIX "${${PROJECT_NAME}_RELEASE_POSTFIX}")
set_target_properties(${PROJECT_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set_target_properties(${PROJECT_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# The project lib name gives a name to the library. This name is used in pkgconfig file.
set(PROJECT_LIB_NAME ${PROJECT_NAME}${${PROJECT_NAME}_RELEASE_POSTFIX})
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(PROJECT_LIB_NAME ${PROJECT_NAME}${${PROJECT_NAME}_DEBUG_POSTFIX})
endif()

# Compile options
include(cmake/Warnings.cmake)
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_17)
target_compile_warnings(${PROJECT_NAME})

# Compile definitions
target_compile_definitions(${PROJECT_NAME} PRIVATE "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:_CRT_SECURE_NO_WARNINGS>")

# Generate export header to provide export macros for shared library and attach it to the target
include(GenerateExportHeader)
generate_export_header(
  ${PROJECT_NAME}
  BASE_NAME ${PROJECT_ID}
  EXPORT_FILE_NAME include/${PROJECT_ID_LOWER}/export.h
)
target_compile_definitions(
  ${PROJECT_NAME} PUBLIC "$<$<NOT:$<BOOL:${BUILD_SHARED_LIBS}>>:${PROJECT_NAME}_STATIC_DEFINE>"
)

# Link dependencies


# BUILD_INTERFACE specifies where to find includes during build time here we set the include directory to be our src
# include directory as well as CMAKE_CURRENT_BINARY_DIR, which is where the generated export.h file is located. the
# command must be included in double quotes so the two directories, separated by a ';' can both be used (cmake needs it
# to be a string)
target_include_directories(
  ${PROJECT_NAME} PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include;${CMAKE_CURRENT_BINARY_DIR}/include>"
)

# -------------------------------------------------------------------------------------------------------------------- #
# Create an installable target. This allows users to install and find the library via : `find_package(${PROJECT_NAME}
# REQUIRED shared)` or `find_package(${PROJECT_NAME} REQUIRED static)`.
# -------------------------------------------------------------------------------------------------------------------- #
if(${PROJECT_ID}_INSTALL)
  include(cmake/Project-install.cmake)
endif()
