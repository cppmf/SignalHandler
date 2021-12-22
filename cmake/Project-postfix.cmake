#[=====================================================================================================================[

  This module define postfix to apply to the target

#]=====================================================================================================================]

# For debug libs and exes, add "_d" postfix
set(${PROJECT_NAME}_DEFAULT_DEBUG_POSTFIX "_d")

# For static lib add "_static" postfix
set(${PROJECT_NAME}_DEFAULT_STATIC_POSTFIX "_static")

# Prefix for x64
if(WIN32)
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(${PROJECT_NAME}_WIN32_POSTFIX "_x64")
  else()
    set(${PROJECT_NAME}_WIN32_POSTFIX "")
  endif()
endif()

# Postfix for static lib
if(NOT BUILD_SHARED_LIBS)
  set(${PROJECT_NAME}_DEBUG_POSTFIX "${${PROJECT_NAME}_WIN32_POSTFIX}${${PROJECT_NAME}_DEFAULT_DEBUG_POSTFIX}${${PROJECT_NAME}_DEFAULT_STATIC_POSTFIX}")
  set(${PROJECT_NAME}_RELEASE_POSTFIX "${${PROJECT_NAME}_WIN32_POSTFIX}${${PROJECT_NAME}_DEFAULT_STATIC_POSTFIX}")
endif()

# Postfix for shared lib
if(BUILD_SHARED_LIBS)
  set(${PROJECT_NAME}_DEBUG_POSTFIX "${${PROJECT_NAME}_WIN32_POSTFIX}${${PROJECT_NAME}_DEFAULT_DEBUG_POSTFIX}")
  set(${PROJECT_NAME}_RELEASE_POSTFIX "${${PROJECT_NAME}_WIN32_POSTFIX}")
endif()
