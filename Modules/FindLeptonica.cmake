if (TARGET Leptonica::Leptonica)
  set(LEPTONICA_FOUND TRUE)
  set(Leptonica_FOUND TRUE)
  return ()
endif ()

if (Leptonica_INCLUDE_DIR AND Leptonica_LIBRARY)
  set(Leptonica_FIND_QUIETLY TRUE)
endif ()

find_package(PkgConfig)
if (PKGCONFIG_FOUND)
  pkg_check_modules(PC_Leptonica leptonica)
endif ()

find_path(Leptonica_INCLUDE_DIR
  NAMES leptonica/allheaders.h
  PATHS
    ${PC_Leptonica_INCLUDEDIR}
    ${PC_Leptonica_INCLUDE_DIR}
  )

set(Leptonica_FIND_LIBRARIES
  leptonica
  )

if (Leptonica_INCLUDE_DIR)
  file(READ "${Leptonica_INCLUDE_DIR}/leptonica/allheaders.h" Leptonica_VERSION_CONTENT)

  string(REGEX MATCH "#define +LIBLEPT_MAJOR_VERSION +([0-9]+)" _dummy "${Leptonica_VERSION_CONTENT}")
  set(Leptonica_MAJOR_VERSION "${CMAKE_MATCH_1}")

  string(REGEX MATCH "#define +LIBLEPT_MINOR_VERSION +([0-9]+)" _dummy "${Leptonica_VERSION_CONTENT}")
  set(Leptonica_MINOR_VERSION "${CMAKE_MATCH_1}")

  string(REGEX MATCH "#define +LIBLEPT_PATCH_VERSION +([0-9]+)" _dummy "${Leptonica_VERSION_CONTENT}")
  set(Leptonica_PATCH_VERSION "${CMAKE_MATCH_1}")

  set(Leptonica_VERSION "${Leptonica_MAJOR_VERSION}.${Leptonica_MINOR_VERSION}.${Leptonica_PATCH_VERSION}")
  list(APPEND Leptonica_FIND_LIBRARIES "leptonica-${Leptonica_VERSION}")
endif ()

find_library(Leptonica_LIBRARY
  NAMES ${Leptonica_FIND_LIBRARIES}
  PATHS
    ${PC_Leptonica_LIBDIR}
    ${PC_Leptonica_LIBRARIES_DIRS}
  )

unset(Leptonica_FIND_LIBRARIES)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Leptonica DEFAULT_MSG Leptonica_INCLUDE_DIR Leptonica_LIBRARY)

mark_as_advanced(Leptonica_INCLUDE_DIR Leptonica_LIBRARY)

if (Leptonica_FOUND OR LEPTONICA_FOUND)
  set(Leptonica_FOUND 1)
  set(Leptonica_INCLUDE_DIRS ${Leptonica_INCLUDE_DIR})
  set(Leptonica_LIBRARIES "${Leptonica_LIBRARY}")
endif()

if (Leptonica_FOUND AND NOT TARGET Leptonica::Leptonica)
  add_library(Leptonica::Leptonica INTERFACE IMPORTED)
  set_property(TARGET Leptonica::Leptonica PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${Leptonica_INCLUDE_DIR}")
  set_property(TARGET Leptonica::Leptonica PROPERTY INTERFACE_LINK_LIBRARIES "${Leptonica_LIBRARY}")
endif ()
