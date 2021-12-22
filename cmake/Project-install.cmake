#[=====================================================================================================================[


#]=====================================================================================================================]

# Define GNU standard installation directories
include(GNUInstallDirs)

# Include module with function 'write_basic_package_version_file'
include(CMakePackageConfigHelpers)

# -------------------------------------------------------------------------------------------------------------------- #
# Definition
# -------------------------------------------------------------------------------------------------------------------- #

# Define the type of library which is built.
# It can be shared or static depending on the value of BUILD_SHARED_LIBS.
if(BUILD_SHARED_LIBS)
  set(type shared)
else()
  set(type static)
endif()

# Define the folder path where the project configuration files will be stored
if(NOT DEFINED ${PROJECT_NAME}_CMAKE_DIR)
  set(${PROJECT_NAME}_CMAKE_DIR
      "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_ID_LOWER}"
      CACHE STRING "Path to ${PROJECT_NAME} CMake files"
  )
endif()

# Define project lib directory
if(NOT DEFINED ${PROJECT_ID}_LIB_DIR)
  set(${PROJECT_ID}_LIB_DIR
      ${CMAKE_INSTALL_LIBDIR}
      CACHE
        STRING
        "Installation directory for libraries, a relative path that will be joined to ${CMAKE_INSTALL_PREFIX} or an absolute path."
  )
endif()

# Define project include directory
if(NOT DEFINED ${PROJECT_ID}_INCLUDE_DIR)
  set(${PROJECT_ID}_INCLUDE_DIR
      ${CMAKE_INSTALL_INCLUDEDIR}
      CACHE
        STRING
        "Installation directory for include files, a relative path that will be joined with ${CMAKE_INSTALL_PREFIX} or an absolute path."
  )
endif()

# Define pkgconfig directory
if(NOT DEFINED ${PROJECT_ID}_PKGCONFIG_DIR)
  set(${PROJECT_ID}_PKGCONFIG_DIR
      ${CMAKE_INSTALL_LIBDIR}/pkgconfig
      CACHE
        PATH
        "Installation directory for pkgconfig (.pc) files, a relative path that will be joined with ${CMAKE_INSTALL_PREFIX} or an absolute path."
  )
endif()


# -------------------------------------------------------------------------------------------------------------------- #
# TODO
# -------------------------------------------------------------------------------------------------------------------- #
target_include_directories(${PROJECT_NAME}
        PUBLIC
        $<INSTALL_INTERFACE:${${PROJECT_ID}_INCLUDE_DIR}>
        )

# -------------------------------------------------------------------------------------------------------------------- #
# config-version.cmake version file
# -------------------------------------------------------------------------------------------------------------------- #

set(version_config ${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake)

# Create a version file for the project to be used by find_package()
write_basic_package_version_file(
  ${version_config}
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)

# Install the version files
install(FILES ${version_config} DESTINATION ${${PROJECT_NAME}_CMAKE_DIR})

# -------------------------------------------------------------------------------------------------------------------- #
# config.cmake project files
# -------------------------------------------------------------------------------------------------------------------- #

set(project_config ${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config.cmake)

#
configure_package_config_file(
  ${CMAKE_CURRENT_LIST_DIR}/Project-config.cmake.in ${project_config} INSTALL_DESTINATION ${${PROJECT_NAME}_CMAKE_DIR}
)

# Install the project files
install(FILES ${project_config} DESTINATION ${${PROJECT_NAME}_CMAKE_DIR})

# -------------------------------------------------------------------------------------------------------------------- #
# .pc project pkgconfig file
# -------------------------------------------------------------------------------------------------------------------- #

set(pkg_config ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.pc)

# Define project lib directory for pkgconfig
set(libdir_for_pkgconfig_file "\${exec_prefix}/${${PROJECT_ID}_LIB_DIR}")

# Define project include directory for pkgconfig
set(includedir_for_pkgconfig_file "\${prefix}/${${PROJECT_ID}_INCLUDE_DIR}")

# Create pkgconfig file
configure_file("${CMAKE_CURRENT_LIST_DIR}/Project-pkg-config.in" "${pkg_config}" @ONLY)

# Install pkgconfig files
install(FILES "${pkg_config}" DESTINATION "${${PROJECT_ID}_PKGCONFIG_DIR}")

# -------------------------------------------------------------------------------------------------------------------- #
# Install targets & files
# -------------------------------------------------------------------------------------------------------------------- #

set(targets_export_name ${PROJECT_NAME}-${type}-targets)

# Install the library.
install(
  TARGETS ${PROJECT_NAME}
  EXPORT ${targets_export_name}
  LIBRARY DESTINATION ${${PROJECT_ID}_LIB_DIR}
  ARCHIVE DESTINATION ${${PROJECT_ID}_LIB_DIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Use a namespace because CMake provides better diagnostics for namespaced imported targets.
export(
  TARGETS ${PROJECT_NAME}
  NAMESPACE ${PROJECT_NAMESPACE}::
  FILE ${PROJECT_BINARY_DIR}/${targets_export_name}.cmake
)

install(
  EXPORT ${targets_export_name}
  NAMESPACE ${PROJECT_NAMESPACE}::
  DESTINATION ${${PROJECT_NAME}_CMAKE_DIR}
)

# Install header files
install(DIRECTORY "${${PROJECT_NAME}_SOURCE_DIR}/include/" "${${PROJECT_ID}_INCLUDE_DIR}/" TYPE INCLUDE)
install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include/" "${${PROJECT_ID}_INCLUDE_DIR}/" TYPE INCLUDE)
target_include_directories(${PROJECT_NAME} PUBLIC $<INSTALL_INTERFACE:${${PROJECT_ID}_INCLUDE_DIR}>)

# Install pdb files
if(DEFINED ${PROJECT_NAME}_SHARED_LIBS)
  install(
    FILES $<TARGET_PDB_FILE:${PROJECT_NAME}>
    DESTINATION ${${PROJECT_ID}_LIB_DIR}
    OPTIONAL
  )
endif()

# Install pkgconfig files
install(FILES "${pkg_config}" DESTINATION "${${PROJECT_ID}_PKGCONFIG_DIR}")

# Install LICENSE file
install(
  FILES ${CMAKE_SOURCE_DIR}/LICENSE
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_ID_LOWER}
  COMPONENT ${PROJECT_NAME}_Development
)

# Install README file
install(
  FILES ${CMAKE_SOURCE_DIR}/README.md
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_ID_LOWER}
  COMPONENT ${PROJECT_NAME}_Development
)
