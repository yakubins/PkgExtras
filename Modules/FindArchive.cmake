if (TARGET Archive::Archive)
  set(Archive_FOUND TRUE)
  set(ARCHIVE_FOUND TRUE)
  return ()
endif ()

if (Archive_INCLUDE_DIR AND Archive_LIBRARY)
  set(Archive_FIND_QUIETLY TRUE)
endif ()

find_path(Archive_INCLUDE_DIR
  NAMES archive.h
  )

find_library(Archive_LIBRARY
  NAMES archive archive_static
  )

unset(Archive_FIND_LIBRARIES)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Archive DEFAULT_MSG Archive_INCLUDE_DIR Archive_LIBRARY)

mark_as_advanced(Archive_INCLUDE_DIR Archive_LIBRARY)

if (Archive_FOUND OR ARCHIVE_FOUND)
  set(Archive_FOUND 1)
  set(Archive_INCLUDE_DIRS ${Archive_INCLUDE_DIR})
  set(Archive_LIBRARIES "${Archive_LIBRARY}")
endif()

if (Archive_FOUND AND NOT TARGET Archive::Archive)
  add_library(Archive::Archive INTERFACE IMPORTED)
  set_property(TARGET Archive::Archive PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${Archive_INCLUDE_DIR}")
  set_property(TARGET Archive::Archive PROPERTY INTERFACE_LINK_LIBRARIES "${Archive_LIBRARY}")
endif ()
