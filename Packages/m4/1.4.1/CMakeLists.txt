cmake_minimum_required(VERSION 3.10)
project(m4 VERSION 1.4.1 LANGUAGES C)

include(GNUInstallDirs)

include(CheckTypeSize)
include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckFunctionExists)
include(CheckSymbolExists)
include(CheckCSourceCompiles)

set(PACKAGE_NAME "GNU M4")
set(PACKAGE_TARNAME "${PROJECT_NAME}")
set(PACKAGE_VERSION "${PROJECT_VERSION}")
set(PACKAGE_STRING "${PACKAGE_NAME} ${PROJECT_VERSION}")
set(PACKAGE_BUGREPORT "bug-m4@gnu.org")

set(PRODUCT "${PROJECT_NAME}")
set(VERSION "${PROJECT_VERSION}")

option(ENABLE_CHANGEWORD "Enable -W and changeword() builtin" OFF)
option(USE_STACKOVF "Stackovf" OFF)

check_type_size("size_t" SIZEOF_SIZE_T)

set(CMAKE_EXTRA_INCLUDE_FILES_SAVE CMAKE_EXTRA_INCLUDE_FILES)
set(CMAKE_EXTRA_INCLUDE_FILES sys/resource.h)
check_type_size(rlim_t SIZEOF_RLIM_T)
set(CMAKE_EXTRA_INCLUDE_FILES ${CMAKE_EXTRA_INCLUDE_FILES_SAVE})

set(CMAKE_EXTRA_INCLUDE_FILES_SAVE CMAKE_EXTRA_INCLUDE_FILES)
set(CMAKE_EXTRA_INCLUDE_FILES signal.h)
check_type_size(stack_t SIZEOF_STACK_T)
set(CMAKE_EXTRA_INCLUDE_FILES ${CMAKE_EXTRA_INCLUDE_FILES_SAVE})

check_include_file(alloca.h       HAVE_ALLOCA_H)
check_include_file(inttypes.h     HAVE_INTTYPES_H)
check_include_file(limits.h       HAVE_LIMITS_H)
check_include_file(memory.h       HAVE_MEMORY_H)
check_include_file(siginfo.h      HAVE_SIGINFO_H)
check_include_file(stdint.h       HAVE_STDINT_H)
check_include_file(stdlib.h       HAVE_STDLIB_H)
check_include_file(strings.h      HAVE_STRINGS_H)
check_include_file(string.h       HAVE_STRING_H)
check_include_file(sys/stat.h     HAVE_SYS_STAT_H)
check_include_file(sys/types.h    HAVE_SYS_TYPES_H)
check_include_file(unistd.h       HAVE_UNISTD_H)
check_include_file(minix/config.h HAVE_MINIX_CONFIG_H)

check_include_files("stdlib.h;stdarg.h;string.h;float.h" STDC_HEADERS)

check_function_exists(ecvt        HAVE_ECVT)
check_function_exists(mkstemp     HAVE_MKSTEMP)
check_function_exists(sigaction   HAVE_SIGACTION)
check_function_exists(sigaltstack HAVE_SIGALTSTACK)
check_function_exists(sigstack    HAVE_SIGSTACK)
check_function_exists(sigvec      HAVE_SIGVEC)
check_function_exists(strerror    HAVE_STRERROR)
check_function_exists(strtol      HAVE_STRTOL)
check_function_exists(tmpfile     HAVE_VPRINTF)
check_function_exists(vprintf     HAVE_TMPFILE)

check_symbol_exists(ecvt       stdlib.h HAVE_EFGCVT)
check_symbol_exists(sigcontext signal.h HAVE_SIGCONTEXT)
check_symbol_exists(_AIX       ""       _ALL_SOURCE)

set(C_ALLOCA 0)
set(PROTOTYPES 0)
set(WITH_DMALLOC 0)
set(HAVE_DOPRNT 0)
set(STACK_DIRECTION 0)

set(DEFINE_SIZE_T "#define size_t unsigned")
if (SIZEOF_SIZE_T)
  set(DEFINE_SIZE_T "/* #undef size_t */")
elseif (CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(DEFINE_SIZE_T "#define size_t unsigned long long")
endif ()

set(DEFINE_RLIM_T "#define rlim_t int")
if (SIZEOF_RLIM_T)
  set(DEFINE_RLIM_T "/* #undef rlim_t */")
endif ()

set(DEFINE_STACK_T "#define stack_t struct sigaltstack")
if (SIZEOF_STACK_T)
  set(DEFINE_STACK_T "/* #undef stack_t */")
endif ()

if (HAVE_MINIX_CONFIG_H)
  set(_POSIX_SOURCE 1)
  set(_POSIX_1_SOURCE 2)
  set(_MINIX 1)
endif ()

foreach (_func _getb67 GETB67 getb6)
  check_c_source_compiles("
    /* Define ${_func} to an innocuous variant, in case <limits.h> declares ${_func}.
       For example, HP-UX 11i <limits.h> declares gettimeofday.  */
    #define ${_func} innocuous_${_func}

    /* System header to define __stub macros and hopefully few prototypes,
        which can conflict with char ${_func} (); below.
        Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
        <limits.h> exists even on freestanding compilers.  */

    #ifdef __STDC__
    # include <limits.h>
    #else
    # include <assert.h>
    #endif

    #undef ${_func}

    /* Override any gcc2 internal prototype to avoid an error.  */
    #ifdef __cplusplus
    extern \"C\"
    {
    #endif
    /* We use char because int might match the return type of a gcc2
       builtin and then its argument prototype would still apply.  */
    char ${_func} ();
    /* The GNU C library defines this for functions which it implements
        to always fail with ENOSYS.  Some functions are actually named
        something starting with __ and the normal name is an alias.  */
    #if defined (__stub_${_func}) || defined (__stub___${_func})
    choke me
    #else
    char (*f) () = ${_func};
    #endif
    #ifdef __cplusplus
    }
    #endif

    int main ()
    {
      return f != ${_func};
    }
    " HAVE_FUNC_${_func})
  if (HAVE_FUNC_${_func})
    set(CRAY_STACKSEG_END ${_func})
    break()
  endif ()
endforeach ()

check_c_source_compiles("
int
main ()
{
/* FIXME: Include the comments suggested by Paul. */
#ifndef __cplusplus
  /* Ultrix mips cc rejects this.  */
  typedef int charset[2];
  const charset x;
  /* SunOS 4.1.1 cc rejects this.  */
  char const *const *ccp;
  char **p;
  /* NEC SVR4.0.2 mips cc rejects this.  */
  struct point {int x, y;};
  static struct point const zero = {0,0};
  /* AIX XL C 1.02.0.0 rejects this.
     It does not let you subtract one const X* pointer from another in
     an arm of an if-expression whose if-part is not a constant
     expression */
  const char *g = \"string\";
  ccp = &g + (g ? g-g : 0);
  /* HPUX 7.0 cc rejects these. */
  ++ccp;
  p = (char**) ccp;
  ccp = (char const *const *) p;
  { /* SCO 3.2v4 cc rejects this.  */
    char *t;
    char const *s = 0 ? (char *) 0 : (char const *) 0;

    *t++ = 0;
  }
  { /* Someone thinks the Sun supposedly-ANSI compiler will reject this.  */
    int x[] = {25, 17};
    const int *foo = &x[0];
    ++foo;
  }
  { /* Sun SC1.0 ANSI compiler rejects this -- but not the above. */
    typedef const int *iptr;
    iptr p = 0;
    ++p;
  }
  { /* AIX XL C 1.02.0.0 rejects this saying
       \"k.c\", line 2.27: 1506-025 (S) Operand must be a modifiable lvalue. */
    struct s { int j; const int *ap[3]; };
    struct s *b; b->j = 5;
  }
  { /* ULTRIX-32 V3.1 (Rev 9) vcc rejects this */
    const int foo = 10;
  }
#endif

  ;
  return 0;
}
" HAS_CONST)

set(DEFINE_CONST "#define const")
if (HAS_CONST)
  set(DEFINE_CONST "/* #undef const */")
endif ()

check_c_source_compiles("
#include <sys/types.h>
#include <signal.h>
int main (void)
{
  return *(signal (0, 0)) (0) == 1;
}
" HAS_INT_SIGNAL)

set(RETSIGTYPE void)
if (HAS_INT_SIGNAL)
  set(RETSIGTYPE int)
endif ()

check_c_source_compiles("
#include <alloca.h>
int main ()
{
  char *p = (char *) alloca (2 * sizeof (int));
  return 0;
}
" HAVE_ALLOCA)

if (WIN32)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sys/signal.h"
"#ifndef _SYS_SIGNAL_H
#define _SYS_SIGNAL_H 1

#ifdef	__cplusplus
extern \"C\" {
#endif

#define SIGINT 0
#define SIG_IGN 0

#define signal(sig, func)

#ifdef	__cplusplus
}
#endif

#endif /* _SYS_SIGNAL_H */
")
endif ()

add_definitions(-DHAVE_CONFIG_H)
configure_file(config.h.cmake "${CMAKE_CURRENT_BINARY_DIR}/config.h" @ONLY UNIX)

set(libm4_HEADERS
  acconfig.h
  lib/getopt.h
  lib/obstack.h
  lib/regex.h
  )
 
set(libm4_SOURCES
  lib/alloca.c
  lib/error.c
  lib/getopt.c
  lib/getopt1.c
  lib/obstack.c
  lib/regex.c
  lib/strtol.c
  lib/xmalloc.c
  lib/xstrdup.c
  )

set(libm4_DATAFILES
  aclocal.m4
  BACKLOG
  c-boxes.el
  ChangeLog
  checks/01.define
  checks/02.arguments
  checks/03.arguments
  checks/04.arguments
  checks/05.arguments
  checks/06.pseudo_argu
  checks/07.pseudo_argu
  checks/08.pseudo_argu
  checks/09.pseudo_argu
  checks/10.pseudo_argu
  checks/11.undefine
  checks/12.defn
  checks/13.pushdef
  checks/14.pushdef
  checks/15.indir
  checks/16.ifdef
  checks/17.ifelse
  checks/18.ifelse
  checks/19.loops
  checks/20.loops
  checks/21.dumpdef
  checks/22.trace
  checks/23.dnl
  checks/24.changequote
  checks/25.changequote
  checks/26.changequote
  checks/27.changecom
  checks/28.changecom
  checks/29.m4wrap
  checks/30.include
  checks/31.include
  checks/32.include
  checks/33.divert
  checks/34.divert
  checks/35.undivert
  checks/36.undivert
  checks/37.undivert
  checks/38.divnum
  checks/39.cleardiv
  checks/40.cleardiv
  checks/41.len
  checks/42.index
  checks/43.regexp
  checks/44.regexp
  checks/45.substr
  checks/46.translit
  checks/47.patsubst
  checks/48.patsubst
  checks/49.format
  checks/50.incr
  checks/51.eval
  checks/52.eval
  checks/53.esyscmd
  checks/54.sysval
  checks/55.errprint
  checks/56.errprint
  checks/57.m4exit
  checks/check-them
  checks/foo
  checks/get-them
  checks/incl.m4
  checks/Makefile.in
  checks/stamp-checks
  config.h.in
  configure
  configure.in
  COPYING
  doc/m4.info
  doc/m4.texinfo
  doc/Makefile.in
  doc/stamp-vti
  doc/texinfo.tex
  doc/version.texi
  examples/capitalize.m4
  examples/comments.m4
  examples/ddivert.m4
  examples/debug.m4
  examples/esyscmd.m4
  examples/exp.m4
  examples/file.m4
  examples/foreach.m4
  examples/forloop.m4
  examples/fstab.m4
  examples/hanoi.m4
  examples/incl-test.m4
  examples/include.m4
  examples/indir.m4
  examples/Makefile.in
  examples/misc.m4
  examples/multiquotes.m4
  examples/patsubst.m4
  examples/pushpop.m4
  examples/regexp.m4
  examples/reverse.m4
  examples/stackovf.sh
  examples/sync-lines.m4
  examples/sysv-args.m4
  examples/trace.m4
  examples/translit.m4
  examples/undivert.incl
  examples/undivert.m4
  examples/wrap.m4
  INSTALL
  install-sh
  lib/COPYING.LIB
  lib/Makefile.in
  lib/TAGS
  Makefile.in
  mkinstalldirs
  NEWS
  README
  src/ansi2knr.1
  src/Makefile.in
  src/TAGS
  stamp-h.in
  THANKS
  TODO
  config.h.cmake
  )

set(libm4_INCLUDES
  "${CMAKE_CURRENT_BINARY_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/lib"
  )

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${libm4_HEADERS} ${libm4_SOURCES} ${libm4_DATAFILES})
add_library(m4_static STATIC ${libm4_HEADERS} ${libm4_SOURCES} ${libm4_DATAFILES})
target_include_directories(m4_static PUBLIC "$<BUILD_INTERFACE:${libm4_INCLUDES}>")
target_compile_definitions(m4_static PRIVATE "${libm4_DEFINITIONS}")
set_target_properties(m4_static PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
set_property(TARGET m4_static PROPERTY POSITION_INDEPENDENT_CODE ON)

add_library(M4::M4 ALIAS m4_static)

set(m4_HEADERS
  src/m4.h
  )

set(m4_SOURCES
  src/builtin.c
  src/debug.c
  src/eval.c
  src/format.c
  src/freeze.c
  src/input.c
  src/m4.c
  src/macro.c
  src/output.c
  src/path.c
  src/symtab.c
  )

if (USE_STACKOVF)
  list(APPEND m4_SOURCES src/stackovf.c)
endif ()
  
source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${m4_HEADERS} ${m4_SOURCES} ${m4_DATAFILES})
add_executable(m4 ${m4_HEADERS} ${m4_SOURCES} ${m4_DATAFILES})
target_link_libraries(m4 PRIVATE M4::M4)

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES src/ansi2knr.c)
add_executable(ansi2knr src/ansi2knr.c)
target_link_libraries(ansi2knr PRIVATE M4::M4)

install(TARGETS m4
  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
  )
