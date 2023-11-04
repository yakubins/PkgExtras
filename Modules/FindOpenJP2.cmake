if (TARGET OpenJP2::OpenJP2)
  set(OpenJP2_FOUND TRUE)
  set(OpenJP2_FOUND TRUE)
  return ()
endif ()

if (OpenJP2_INCLUDE_DIR AND OpenJP2_LIBRARY)
  set(OpenJP2_FIND_QUIETLY TRUE)
endif ()

find_package(PkgConfig)
if (PKGCONFIG_FOUND)
  pkg_check_modules(PC_OpenJP2 openjp2)
endif ()

find_path(OpenJP2_INCLUDE_DIR
  NAMES openjpeg.h
  PATHS
    ${PC_OpenJP2_INCLUDEDIR}
    ${PC_OpenJP2_INCLUDE_DIR}
  PATH_SUFFIXES
    openjpeg-2.5
  )

find_library(OpenJP2_LIBRARY
  NAMES openjp2
  PATHS
    ${PC_OpenJP2_LIBDIR}
    ${PC_OpenJP2_LIBRARIES_DIRS}
  )

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(OpenJP2 DEFAULT_MSG OpenJP2_INCLUDE_DIR OpenJP2_LIBRARY)

mark_as_advanced(OpenJP2_INCLUDE_DIR OpenJP2_LIBRARY)

if (OPENJP2_FOUND OR OpenJP2_FOUND)
  set(OpenJP2_FOUND TRUE)
  set(OpenJP2_INCLUDE_DIRS ${OpenJP2_INCLUDE_DIR})
  set(OpenJP2_LIBRARIES ${OpenJP2_LIBRARY})
endif()

if (OpenJP2_FOUND AND NOT TARGET OpenJP2::OpenJP2)
  add_library(OpenJP2::OpenJP2 INTERFACE IMPORTED)
  set_property(TARGET OpenJP2::OpenJP2 PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${OpenJP2_INCLUDE_DIRS})
  set_property(TARGET OpenJP2::OpenJP2 PROPERTY INTERFACE_LINK_LIBRARIES ${OpenJP2_LIBRARIES})
endif ()
