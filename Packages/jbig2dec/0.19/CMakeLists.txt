cmake_minimum_required(VERSION 3.10)
project(jbig2dec VERSION 0.19 LANGUAGES C)

include(GNUInstallDirs)

include (CheckTypeSize)
include (CheckIncludeFile)
include (CheckFunctionExists)

set(JBIG2_MAJOR_VERSION ${PROJECT_VERSION_MAJOR})
set(JBIG2_MINOR_VERSION ${PROJECT_VERSION_MINOR})
set(JBIG2_VERSION "${PROJECT_VERSION}")
set(JBIG2_PACKAGE "jbig2dec")

set(JBIG2DEC_LT_CURRENT 0)
set(JBIG2DEC_LT_REVISION 0)
set(JBIG2DEC_LT_AGE 0)

set(JBIG2_INT32_T "int")
set(JBIG2_INT16_T "short")
set(JBIG2_INT8_T "char")

check_type_size("char"       SIZEOF_CHAR)
check_type_size("short"      SIZEOF_SHORT)
check_type_size("int"        SIZEOF_INT)
check_type_size("long"       SIZEOF_LONG)
check_type_size("long long"  SIZEOF_LONG_LONG)

check_include_file("stdint.h"      HAVE_STDINT_H)
check_include_file("string.h"      HAVE_STRING_H)
check_function_exists(getopt_long  HAVE_GETOPT_LONG)

option(jbig2dec_BUILD_STATIC "Create static libraries if on" OFF)
if (jbig2dec_BUILD_STATIC)
  set(jbig2dec_BUILD_TYPE STATIC)
else ()
  set(jbig2dec_BUILD_TYPE SHARED)
endif ()

find_package(PNG 1.6)
if (PNG_FOUND)
  set(HAVE_LIBPNG 1)
endif ()

if (WIN32)
  add_definitions(-DWIN32 -DWINVER=0x0601 -D_WIN32_WINNT=0x0601)
endif ()

set(jbig2dec_PUBLIC_HEADERS
  jbig2.h
  )

set(jbig2dec_HEADERS
  config_win32.h
  jbig2_arith.h
  jbig2_arith_iaid.h
  jbig2_arith_int.h
  jbig2_generic.h
  jbig2_halftone.h
  jbig2_huffman.h
  jbig2_hufftab.h
  jbig2_image.h
  jbig2_image_rw.h
  jbig2_mmr.h
  jbig2_page.h
  jbig2_priv.h
  jbig2_refinement.h
  jbig2_segment.h
  jbig2_symbol_dict.h
  jbig2_text.h
  )

set(jbig2dec_SOURCES
  jbig2.c
  jbig2_arith.c
  jbig2_arith_iaid.c
  jbig2_arith_int.c
  jbig2_generic.c
  jbig2_halftone.c
  jbig2_huffman.c
  jbig2_hufftab.c
  jbig2_image.c
  jbig2_image_pbm.c
  jbig2_mmr.c
  jbig2_page.c
  jbig2_refinement.c
  jbig2_segment.c
  jbig2_symbol_dict.c
  jbig2_text.c
  )

set(jbig2dec_DATAFILES
  annex-h.jbig2
  autogen.sh
  configure.ac.in
  jbig2dec.pc.in
  jbig2dec.1
  msvc.mak
  CHANGES
  COPYING
  LICENSE
  README
  Makefile.am
  Makefile.unix
  test_jbig2dec.py
  )

set(jbig2dec_LIBRARIES
  )

set(jbig2dec_DEFINITIONS
  HAVE_CONFIG_H
  )

if (HAVE_LIBPNG)
  list(APPEND jbig2dec_SOURCES jbig2_image_png.c)
  list(APPEND jbig2dec_LIBRARIES PNG::PNG)
endif ()

configure_file(config.h.cmake "${CMAKE_CURRENT_BINARY_DIR}/config.h" @ONLY)
configure_file(config_types.h.cmake "${CMAKE_CURRENT_BINARY_DIR}/config_types.h" @ONLY)

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${jbig2dec_PUBLIC_HEADERS} ${jbig2dec_HEADERS} ${jbig2dec_SOURCES} ${jbig2dec_DATAFILES})
add_library(jbig2dec ${jbig2dec_BUILD_TYPE} ${jbig2dec_PUBLIC_HEADERS} ${jbig2dec_HEADERS} ${jbig2dec_SOURCES} ${jbig2dec_DATAFILES})
target_include_directories(jbig2dec PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>")
target_include_directories(jbig2dec PRIVATE "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>")
target_compile_definitions(jbig2dec PRIVATE "${jbig2dec_DEFINITIONS}")
target_link_libraries(jbig2dec PUBLIC ${jbig2dec_LIBRARIES})
set_target_properties(jbig2dec PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
set_target_properties(jbig2dec PROPERTIES PUBLIC_HEADER "${jbig2dec_PUBLIC_HEADERS}")
set_property(TARGET jbig2dec PROPERTY POSITION_INDEPENDENT_CODE ON)

add_library(JBig2::JBig2 ALIAS jbig2dec)

set(jbig2app_HEADERS
  getopt.h
  memento.h
  os_types.h
  sha1.h
  )

set(jbig2app_SOURCES
  getopt.c
  getopt1.c
  memcmp.c
  memento.c
  sha1.c

  jbig2dec.c
  )

set(jbig2app_DATAFILES
  )

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${jbig2app_HEADERS} ${jbig2app_SOURCES} ${jbig2app_DATAFILES})
add_executable(jbig2app ${jbig2app_HEADERS} ${jbig2app_SOURCES} ${jbig2app_DATAFILES})
target_include_directories(jbig2app PRIVATE "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>")
target_compile_definitions(jbig2app PRIVATE HAVE_CONFIG_H)
target_link_libraries(jbig2app PRIVATE JBig2::JBig2)
set_target_properties(jbig2app PROPERTIES OUTPUT_NAME jbig2dec)

if (HAVE_LIBPNG)
  source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES pbm2png.c)
  add_executable(pbm2png pbm2png.c)
  target_include_directories(pbm2png PRIVATE "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>")
  target_compile_definitions(pbm2png PRIVATE HAVE_CONFIG_H JBIG2_USE_STDBOOL_H)
  target_link_libraries(pbm2png PRIVATE JBig2::JBig2)
endif ()

install(TARGETS jbig2dec
  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
  )
