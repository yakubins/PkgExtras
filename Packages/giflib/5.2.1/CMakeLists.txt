cmake_minimum_required(VERSION 3.10)
project(giflib VERSION 5.2.1 LANGUAGES C)

include(GNUInstallDirs)

set(gif_PUBLIC_HEADERS
  gif_lib.h
  )

set(gif_HEADERS
  gif_hash.h
  gif_lib_private.h
  )

set(gif_SOURCES
  dgif_lib.c
  egif_lib.c
  gifalloc.c
  gif_err.c
  gif_font.c
  gif_hash.c
  openbsd-reallocarray.c
  )

set(gif_INCLUDES
  "${CMAKE_CURRENT_BINARY_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}"
  )

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${gif_PUBLIC_HEADERS} ${gif_HEADERS} ${gif_SOURCES})
add_library(gif STATIC ${gif_PUBLIC_HEADERS} ${gif_HEADERS} ${gif_SOURCES})
target_include_directories(gif PUBLIC "$<BUILD_INTERFACE:${gif_INCLUDES}>")
set_target_properties(gif PROPERTIES PUBLIC_HEADER ${gif_PUBLIC_HEADERS})
set_target_properties(gif PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
set_property(TARGET gif PROPERTY POSITION_INDEPENDENT_CODE ON)

add_library(GIF::GIF ALIAS gif)

set(util_HEADERS
  getarg.h
  )

set(util_SOURCES
  getarg.c
  qprintf.c
  quantize.c
  )

set(util_INCLUDES
  "${CMAKE_CURRENT_BINARY_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}"
  )

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${util_HEADERS} ${util_SOURCES})
add_library(util STATIC ${util_HEADERS} ${util_SOURCES})
target_include_directories(util PUBLIC "$<BUILD_INTERFACE:${util_INCLUDES}>")
target_link_libraries(util PUBLIC gif)
set_target_properties(util PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
set_property(TARGET util PROPERTY POSITION_INDEPENDENT_CODE ON)

foreach (_app gifbg gifcolor gifecho giffilter gifhisto gifinto gifsponge gifwedge)
  source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${_app}.c)
  add_executable(${_app} ${_app}.c)
  target_link_libraries(${_app} PRIVATE util)
endforeach ()

set(_INSTALL_TARGETS gif)
foreach (_app gif2rgb gifbuild giffix giftext giftool gifclrmp)
  source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${_app}.c)
  add_executable(${_app} ${_app}.c)
  target_link_libraries(${_app} PRIVATE util)
  list(APPEND _INSTALL_TARGETS ${_app})
endforeach ()

install(TARGETS ${_INSTALL_TARGETS}
  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
  )
