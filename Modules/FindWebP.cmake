if (TARGET WebP::WebP)
  set(WebP_FOUND TRUE)
  set(WEBP_FOUND TRUE)
  return ()
endif ()

if (WebP_INCLUDE_DIR AND WebP_LIBRARY)
  set(WebP_FIND_QUIETLY TRUE)
endif ()

find_package(PkgConfig)
if (PKGCONFIG_FOUND)
  pkg_check_modules(PC_WebP libwebp)
endif ()

find_path(WebP_INCLUDE_DIR
  NAMES webp/decode.h
  PATHS
    ${PC_WebP_INCLUDEDIR}
    ${PC_WebP_INCLUDE_DIR}
  )

find_library(WebP_LIBRARY
  NAMES webp
  PATHS
    ${PC_WebP_LIBDIR}
    ${PC_WebP_LIBRARIES_DIRS}
  )

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(WebP DEFAULT_MSG WebP_INCLUDE_DIR WebP_LIBRARY)

mark_as_advanced(WebP_INCLUDE_DIR WebP_LIBRARY)

if (WEBP_FOUND OR WebP_FOUND)
  set(WebP_FOUND 1)
  set(WebP_INCLUDE_DIRS ${WebP_INCLUDE_DIR})
  set(WebP_LIBRARIES "${WebP_LIBRARY}")
endif()

if (WebP_FOUND AND NOT TARGET WebP::WebP)
  add_library(WebP::WebP INTERFACE IMPORTED)
  set_property(TARGET WebP::WebP PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${WebP_INCLUDE_DIR}")
  set_property(TARGET WebP::WebP PROPERTY INTERFACE_LINK_LIBRARIES "${WebP_LIBRARY}")
endif ()
