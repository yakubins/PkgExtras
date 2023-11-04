if (TARGET AmiVideo::AmiVideo)
  set(AmiVideo_FOUND TRUE)
  return ()
endif ()

if (AmiVideo_INCLUDE_DIR AND AmiVideo_LIBRARY)
  set(AmiVideo_FIND_QUIETLY TRUE)
endif ()

find_package(PkgConfig)
if (PKGCONFIG_FOUND)
  pkg_check_modules(PC_AmiVideo libamivideo)
endif ()

find_path(AmiVideo_INCLUDE_DIR
  NAMES libamivideo/amivideotypes.h
  PATHS
    ${PC_AmiVideo_INCLUDEDIR}
    ${PC_AmiVideo_INCLUDE_DIR}
  )

find_library(AmiVideo_LIBRARY
  NAMES amivideo libamivideo
  PATHS
    ${PC_AmiVideo_LIBDIR}
    ${PC_AmiVideo_LIBRARIES_DIRS}
  )

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(AmiVideo DEFAULT_MSG AmiVideo_INCLUDE_DIR AmiVideo_LIBRARY)

mark_as_advanced(AmiVideo_INCLUDE_DIR AmiVideo_LIBRARY)

if (AMIVIDEO_FOUND OR AmiVideo_FOUND)
  set(AmiVideo_FOUND TRUE)
  set(AmiVideo_INCLUDE_DIRS "${AmiVideo_INCLUDE_DIR}")
  set(AmiVideo_LIBRARIES "${AmiVideo_LIBRARY}")
endif()

if (AmiVideo_FOUND AND NOT TARGET AmiVideo::AmiVideo)
  add_library(AmiVideo::AmiVideo INTERFACE IMPORTED)
  set_property(TARGET AmiVideo::AmiVideo PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${AmiVideo_INCLUDE_DIR}")
  set_property(TARGET AmiVideo::AmiVideo PROPERTY INTERFACE_LINK_LIBRARIES "${AmiVideo_LIBRARY}")
endif ()
