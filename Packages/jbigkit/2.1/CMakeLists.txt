cmake_minimum_required(VERSION 3.10)
project(jbigkit VERSION 2.1 LANGUAGES C)

include(GNUInstallDirs)

option(jbigkit_BUILD_STATIC "Create static libraries if on" ON)
if (jbigkit_BUILD_STATIC)
  set(jbigkit_BUILD_TYPE STATIC)
else ()
  set(jbigkit_BUILD_TYPE SHARED)
endif ()

option(jbigkit_USE_INSTALL_SUFFIXE "Use additional subdirectory for public headers" ON)
set(jbigkit_PUBLIC_HEADER_DIR "${CMAKE_INSTALL_INCLUDEDIR}")
if (jbigkit_USE_INSTALL_SUFFIXE)
  set(jbigkit_PUBLIC_HEADER_DIR "${jbigkit_PUBLIC_HEADER_DIR}/jbigkit")
endif ()

if (CMAKE_C_COMPILER_ID MATCHES GNU)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ansi -pedantic")
endif()

if (MSVC)
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_SECURE_NO_WARNINGS)
  if (DEFINED CMAKE_C_FLAGS_DEBUG)
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /DDEBUG")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}" CACHE STRING "" FORCE)
  endif ()
endif ()

if(CMAKE_BUILD_TYPE STREQUAL Debug)
  add_definitions(-DDEBUG)
endif()

set(jbig_HEADERS
  libjbig/jbig.h
  libjbig/jbig_ar.h
  )

set(jbig_SOURCES
  libjbig/jbig.c
  libjbig/jbig_ar.c
  )

set(jbig_DATAFILES
  libjbig/jbig.txt
  )

set(jbig_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/libjbig"
  )

add_library(jbig ${jbigkit_BUILD_TYPE} ${jbig_HEADERS} ${jbig_SOURCES} ${jbig_DATAFILES})
target_include_directories(jbig PUBLIC "$<BUILD_INTERFACE:${jbig_INCLUDES}>")
set_target_properties(jbig PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
set_target_properties(jbig PROPERTIES PUBLIC_HEADER "${jbig_HEADERS}")
set_property(TARGET jbig PROPERTY POSITION_INDEPENDENT_CODE ON)

add_library(JBig::JBig ALIAS jbig)

set(jbig85_HEADERS
  libjbig/jbig85.h
  libjbig/jbig_ar.h
  )

set(jbig85_SOURCES
  libjbig/jbig85.c
  libjbig/jbig_ar.c
  )

set(jbig85_DATAFILES
  libjbig/jbig85.txt
  )

set(jbig85_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/libjbig"
  )

add_library(jbig85 ${jbigkit_BUILD_TYPE} ${jbig85_HEADERS} ${jbig85_SOURCES} ${jbig85_DATAFILES})
target_include_directories(jbig85 PUBLIC "$<BUILD_INTERFACE:${jbig85_INCLUDES}>")
set_target_properties(jbig85 PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
set_target_properties(jbig85 PROPERTIES PUBLIC_HEADER "${jbig85_HEADERS}")
set_property(TARGET jbig85 PROPERTY POSITION_INDEPENDENT_CODE ON)

add_library(JBig85::JBig85 ALIAS jbig85)

add_executable(tstcodec libjbig/tstcodec.c)
target_link_libraries(tstcodec PRIVATE jbig)

add_executable(tstcodec85 libjbig/tstcodec85.c)
target_link_libraries(tstcodec85 PRIVATE jbig85)

add_executable(jbgtopbm pbmtools/jbgtopbm.c)
target_link_libraries(jbgtopbm PRIVATE jbig)

add_executable(jbgtopbm85 pbmtools/jbgtopbm85.c)
target_link_libraries(jbgtopbm85 PRIVATE jbig85)

add_executable(pbmtojbg pbmtools/pbmtojbg.c)
target_link_libraries(pbmtojbg PRIVATE jbig)

add_executable(pbmtojbg85 pbmtools/pbmtojbg85.c)
target_link_libraries(pbmtojbg85 PRIVATE jbig85)

install(TARGETS jbig jbig85 tstcodec tstcodec85 jbgtopbm jbgtopbm85 pbmtojbg pbmtojbg85
  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  PUBLIC_HEADER DESTINATION "${jbigkit_PUBLIC_HEADER_DIR}"
  )
