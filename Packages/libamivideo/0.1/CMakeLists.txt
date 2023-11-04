cmake_minimum_required(VERSION 3.10)
project(libamivideo VERSION 0.1 DESCRIPTION "Amiga (OCS/ECS/AGA) video format conversion library" LANGUAGES C)

include(GNUInstallDirs)

set(VERSION "${PROJECT_VERSION}")
set(prefix "${CMAKE_INSTALL_PREFIX}")
set(exec_prefix "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}")
set(libdir "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
set(includedir "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_INCLUDEDIR}")

set(amivideo_HEADERS
  src/libamivideo/amivideotypes.h
  src/libamivideo/palette.h
  src/libamivideo/screen.h
  src/libamivideo/viewportmode.h
  )

set(amivideo_SOURCES
  src/libamivideo/palette.c
  src/libamivideo/screen.c
  src/libamivideo/viewportmode.c
  )

set(amivideo_DATAFILES
  src/libamivideo/libamivideo.def
  src/libamivideo/libamivideo.vcxproj
  src/libamivideo/libamivideo.vcxproj.filters
  src/libamivideo/Makefile.am
  src/libamivideo.pc.in
  src/libamivideo.sln
  src/Doxyfile
  src/Makefile.am
  AUTHORS
  bootstrap
  ChangeLog
  configure.ac
  COPYING
  INSTALL
  Makefile.am
  NEWS
  README.md
  release.nix
  version
  )

set(amivideo_INCLUDES
  "${CMAKE_CURRENT_BINARY_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/src/libamivideo"
  )

set(amivideo_DEFINITIONS
  LIBAMIVIDEO_EXPORTS
  )

if (WIN32)
  add_definitions(-DWIN32)
endif ()

configure_file(src/libamivideo.pc.in "${CMAKE_CURRENT_BINARY_DIR}/libamivideo.pc" @ONLY UNIX)

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${amivideo_HEADERS} ${amivideo_SOURCES} ${amivideo_DATAFILES})
add_library(amivideo SHARED ${amivideo_HEADERS} ${amivideo_SOURCES} ${amivideo_DATAFILES})
target_include_directories(amivideo PUBLIC "$<BUILD_INTERFACE:${amivideo_INCLUDES}>")
target_compile_definitions(amivideo PRIVATE "${amivideo_DEFINITIONS}")
set_target_properties(amivideo PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
set_target_properties(amivideo PROPERTIES PREFIX "lib")
set_property(TARGET amivideo PROPERTY POSITION_INDEPENDENT_CODE ON)

add_library(AmiVideo::AmiVideo ALIAS amivideo)


source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES tests/chunky.c tests/Makefile.am)
add_executable(chunky tests/chunky.c tests/Makefile.am)
target_link_libraries(chunky PRIVATE AmiVideo::AmiVideo)


install(TARGETS amivideo
  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  )

install(
  FILES "${CMAKE_CURRENT_BINARY_DIR}/libamivideo.pc"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/libamivideo.pc"
  )

install(
  FILES ${amivideo_HEADERS}
  DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/libamivideo"
  )
