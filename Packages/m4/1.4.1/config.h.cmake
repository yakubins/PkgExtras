/* config.h.in.  Generated from configure.in by autoheader.  */
/* Special definitions for GNU m4, processed by autoheader.
   Copyright (C) 1993, 1994 Free Software Foundation, Inc.
   Francois Pinard <pinard@iro.umontreal.ca>, 1993.
*/

/* Define to 1 if the changeword(REGEXP) functionnality is wanted.  */
#cmakedefine ENABLE_CHANGEWORD 1

/* Define to 1 if you have ecvt(3), fcvt(3) and gcvt(3), define to 2 if
   these are declared in <stdlib.h>.  */
#cmakedefine HAVE_EFGCVT 2

/* Define to 1 if #include <signal.h> declares struct sigcontext */
#cmakedefine HAVE_SIGCONTEXT 1

/* Define to the name of the distribution.  */
#cmakedefine PRODUCT "@PRODUCT@"

/* Define to 1 if ANSI function prototypes are usable.  */
#cmakedefine PROTOTYPES 1

/* Define to int if rlim_t is not defined in sys/resource.h */
@DEFINE_RLIM_T@

/* Define to struct sigaltstack if stack_t is not defined in sys/signal.h */
@DEFINE_STACK_T@

/* Define to 1 if using stack overflow detection.  */
#cmakedefine USE_STACKOVF 1

/* Define to the version of the distribution.  */
#cmakedefine VERSION "@VERSION@"

/* Define to 1 for better use of the debugging malloc library.  See 
   site ftp.antaire.com in antaire/src, file dmalloc/dmalloc.tar.gz.  */
#cmakedefine WITH_DMALLOC 1

/* Define to one of `_getb67', `GETB67', `getb67' for Cray-2 and Cray-YMP
   systems. This function is required for `alloca.c' support on those systems.
   */
#cmakedefine CRAY_STACKSEG_END @CRAY_STACKSEG_END@

/* Define to 1 if using `alloca.c'. */
#cmakedefine C_ALLOCA 1

/* Define to 1 if you have `alloca', as a function or macro. */
#cmakedefine HAVE_ALLOCA 1

/* Define to 1 if you have <alloca.h> and it should be used (not on Ultrix).
   */
#cmakedefine HAVE_ALLOCA_H 1

/* Define to 1 if you don't have `vprintf' but do have `_doprnt.' */
#cmakedefine HAVE_DOPRNT 1

/* Define to 1 if you have the `ecvt' function. */
#cmakedefine HAVE_ECVT 1

/* Define to 1 if you have the <inttypes.h> header file. */
#cmakedefine HAVE_INTTYPES_H 1

/* Define to 1 if you have the <limits.h> header file. */
#cmakedefine HAVE_LIMITS_H 1

/* Define to 1 if you have the <memory.h> header file. */
#cmakedefine HAVE_MEMORY_H 1

/* Define to 1 if you have the `mkstemp' function. */
#cmakedefine HAVE_MKSTEMP 1

/* Define to 1 if you have the `sigaction' function. */
#cmakedefine HAVE_SIGACTION 1

/* Define to 1 if you have the `sigaltstack' function. */
#cmakedefine HAVE_SIGALTSTACK 1

/* Define to 1 if you have the <siginfo.h> header file. */
#cmakedefine HAVE_SIGINFO_H 1

/* Define to 1 if you have the `sigstack' function. */
#cmakedefine HAVE_SIGSTACK 1

/* Define to 1 if you have the `sigvec' function. */
#cmakedefine HAVE_SIGVEC 1

/* Define to 1 if you have the <stdint.h> header file. */
#cmakedefine HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#cmakedefine HAVE_STDLIB_H 1

/* Define to 1 if you have the `strerror' function. */
#cmakedefine HAVE_STRERROR 1

/* Define to 1 if you have the <strings.h> header file. */
#cmakedefine HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#cmakedefine HAVE_STRING_H 1

/* Define to 1 if you have the `strtol' function. */
#cmakedefine HAVE_STRTOL 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#cmakedefine HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#cmakedefine HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the `tmpfile' function. */
#cmakedefine HAVE_TMPFILE 1

/* Define to 1 if you have the <unistd.h> header file. */
#cmakedefine HAVE_UNISTD_H 1

/* Define to 1 if you have the `vprintf' function. */
#cmakedefine HAVE_VPRINTF 1

/* Define to the address where bug reports for this package should be sent. */
#cmakedefine PACKAGE_BUGREPORT "@PACKAGE_BUGREPORT@"

/* Define to the full name of this package. */
#cmakedefine PACKAGE_NAME "@PACKAGE_NAME@"

/* Define to the full name and version of this package. */
#cmakedefine PACKAGE_STRING "@PACKAGE_STRING@"

/* Define to the one symbol short name of this package. */
#cmakedefine PACKAGE_TARNAME "@PACKAGE_TARNAME@"

/* Define to the version of this package. */
#cmakedefine PACKAGE_VERSION "@PACKAGE_VERSION@"

/* Define as the return type of signal handlers (`int' or `void'). */
#cmakedefine RETSIGTYPE @RETSIGTYPE@

/* If using the C implementation of alloca, define if you know the
   direction of stack growth for your system; otherwise it will be
   automatically deduced at run-time.
	STACK_DIRECTION > 0 => grows toward higher addresses
	STACK_DIRECTION < 0 => grows toward lower addresses
	STACK_DIRECTION = 0 => direction of growth unknown */
#define STACK_DIRECTION @STACK_DIRECTION@

/* Define to 1 if you have the ANSI C header files. */
#cmakedefine STDC_HEADERS 1

/* Define to 1 if on AIX 3.
   System headers sometimes define this.
   We just want to avoid a redefinition error message.  */
#ifndef _ALL_SOURCE
#cmakedefine _ALL_SOURCE 1
#endif

/* Define to 1 if on MINIX. */
#cmakedefine _MINIX 1

/* Define to 2 if the system does not provide POSIX.1 features except with
   this defined. */
#cmakedefine _POSIX_1_SOURCE 2

/* Define to 1 if you need to in order for `stat' and other things to work. */
#cmakedefine _POSIX_SOURCE 1

/* Define to empty if `const' does not conform to ANSI C. */
@DEFINE_CONST@

/* Define to `unsigned' if <sys/types.h> does not define. */
@DEFINE_SIZE_T@
