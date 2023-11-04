if (TARGET ILBM::ILBM)
  set(ILBM_FOUND TRUE)
  return ()
endif ()

if (ILBM_INCLUDE_DIR AND ILBM_LIBRARY)
  set(ILBM_FIND_QUIETLY TRUE)
endif ()

find_package(PkgConfig)
if (PKGCONFIG_FOUND)
  pkg_check_modules(PC_ILBM libilbm)
endif ()

find_path(ILBM_INCLUDE_DIR
  NAMES libilbm/ilbm.h
  PATHS
    ${PC_ILBM_INCLUDEDIR}
    ${PC_ILBM_INCLUDE_DIR}
  )

find_library(ILBM_LIBRARY
  NAMES ilbm libilbm
  PATHS
    ${PC_ILBM_LIBDIR}
    ${PC_ILBM_LIBRARIES_DIRS}
  )

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ILBM DEFAULT_MSG ILBM_INCLUDE_DIR ILBM_LIBRARY)

mark_as_advanced(ILBM_INCLUDE_DIR ILBM_LIBRARY)

if (ILBM_FOUND)
  set(ILBM_INCLUDE_DIRS "${ILBM_INCLUDE_DIR}")
  set(ILBM_LIBRARIES "${ILBM_LIBRARY}")
endif()

if (ILBM_FOUND AND NOT TARGET ILBM::ILBM)
  add_library(ILBM::ILBM INTERFACE IMPORTED)
  set_property(TARGET ILBM::ILBM PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${ILBM_INCLUDE_DIR}")
  set_property(TARGET ILBM::ILBM PROPERTY INTERFACE_LINK_LIBRARIES "${ILBM_LIBRARY}")
endif ()
