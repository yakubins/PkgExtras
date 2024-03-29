/*
   generated header with missing types for the
   jbig2dec program and library. include this
   after config.h, within the HAVE_CONFIG_H
   ifdef
*/

#ifdef HAVE_STDINT_H
#  include <stdint.h>
#else
#  ifdef JBIG2_REPLACE_STDINT_H
#   include <@JBIG2_STDINT_H@>
#  else
    typedef unsigned @JBIG2_INT32_T@ uint32_t;
    typedef unsigned @JBIG2_INT16_T@ uint16_t;
    typedef unsigned @JBIG2_INT8_T@ uint8_t;
    typedef signed @JBIG2_INT32_T@ int32_t;
    typedef signed @JBIG2_INT16_T@ int16_t;
    typedef signed @JBIG2_INT8_T@ int8_t;
#  endif /* JBIG2_REPLACE_STDINT */
#endif /* HAVE_STDINT_H */

#ifdef JBIG2_USE_STDBOOL_H
#include <stdbool.h>
#endif
