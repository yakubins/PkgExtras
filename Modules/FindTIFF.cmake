if (TARGET TIFF::TIFF)
  set(TIFF_FOUND TRUE)
  return ()
endif ()

if (TIFF_INCLUDE_DIR AND TIFF_LIBRARY)
  set(TIFF_FIND_QUIETLY TRUE)
endif ()

find_package(PkgConfig)
if (PKGCONFIG_FOUND)
  pkg_check_modules(PC_TIFF libTIFF)
endif ()

find_path(TIFF_INCLUDE_DIR
  NAMES tiff.h
  PATHS
    ${PC_TIFF_INCLUDEDIR}
    ${PC_TIFF_INCLUDE_DIR}
  )

find_library(TIFF_LIBRARY
  NAMES tiff
  PATHS
    ${PC_TIFF_LIBDIR}
    ${PC_TIFF_LIBRARIES_DIRS}
  )

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(TIFF DEFAULT_MSG TIFF_INCLUDE_DIR TIFF_LIBRARY)

mark_as_advanced(TIFF_INCLUDE_DIR TIFF_LIBRARY)

if (TIFF_FOUND)
  set(TIFF_INCLUDE_DIRS "${TIFF_INCLUDE_DIR}")
  set(TIFF_LIBRARIES "${TIFF_LIBRARY}")
endif()

if (TIFF_FOUND AND NOT TARGET TIFF::TIFF)
  add_library(TIFF::TIFF INTERFACE IMPORTED)
  set_property(TARGET TIFF::TIFF PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${TIFF_INCLUDE_DIR}")
  set_property(TARGET TIFF::TIFF PROPERTY INTERFACE_LINK_LIBRARIES "${TIFF_LIBRARY}")
endif ()
