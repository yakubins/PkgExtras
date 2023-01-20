cmake_minimum_required(VERSION 3.10)
project(icu VERSION 66.1 LANGUAGES C CXX)

include(GNUInstallDirs)

set(U_IS_BIG_ENDIAN FALSE)
add_definitions(-DU_IS_BIG_ENDIAN=0)

include(CheckIncludeFile)
check_include_file(elf.h HAVE_ELF_H)
if (HAVE_ELF_H)
  add_definitions(-DU_HAVE_ELF_H=1)
else ()
  add_definitions(-DU_HAVE_ELF_H=0)
endif ()

option(ICU_BUILD_STATIC "Create static libraries if on" OFF)
if (ICU_BUILD_STATIC)
  set(ICU_BUILD_TYPE STATIC)
  add_definitions(-DU_STATIC_IMPLEMENTATION)
else ()
  set(ICU_BUILD_TYPE SHARED)
endif ()

if (WIN32)
  add_definitions(-DWIN32 -DWINVER=0x0601 -D_WIN32_WINNT=0x0601)
endif ()

if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic -Wpointer-arith -Wwrite-strings -Wno-long-long")
endif()

if (MSVC)
  set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS} -GF -nologo -utf-8")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -GF -nologo -utf-8")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -EHsc -Zc:wchar_t")
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_SECURE_NO_WARNINGS)
  add_definitions(-DU_ATTRIBUTE_DEPRECATED=)
endif ()

set(ICU_TARGET_LIST "")
macro (ICU_ADD_TARGET _target _type)
  source_group(
    TREE "${CMAKE_CURRENT_SOURCE_DIR}"
    FILES ${${_target}_PUBLIC_HEADERS} ${${_target}_HEADERS} ${${_target}_SOURCES} ${${_target}_DATAFILES}
    )
    
  if ("${_type}" STREQUAL EXECUTABLE)
   add_executable(${_target}
     ${${_target}_PUBLIC_HEADERS}
     ${${_target}_HEADERS}
     ${${_target}_SOURCES}
     ${${_target}_DATAFILES}
     )
  elseif ("${_type}" STREQUAL LIBRARY)
   add_library(${_target} ${ICU_BUILD_TYPE}
     ${${_target}_PUBLIC_HEADERS}
     ${${_target}_HEADERS}
     ${${_target}_SOURCES}
     ${${_target}_DATAFILES}
     )
    set_target_properties(${_target} PROPERTIES VERSION ${PROJECT_VERSION} SOVERSION ${PROJECT_VERSION_MAJOR})
    set_property(TARGET ${_target} PROPERTY POSITION_INDEPENDENT_CODE ON)
  else ()
    message(FATAL_ERROR "Not support type '${_type}'")
  endif ()
  
  if (${_target}_PUBLIC_INCLUDES)
    target_include_directories(${_target} PUBLIC "$<BUILD_INTERFACE:${${_target}_PUBLIC_INCLUDES}>")
  endif ()
  
  if (${_target}_INCLUDES)
    target_include_directories(${_target} PRIVATE "$<BUILD_INTERFACE:${${_target}_INCLUDES}>")
  endif ()
  
  if (${_target}_PUBLIC_DEFINITIONS)
    target_compile_definitions(${_target} PUBLIC "${${_target}_PUBLIC_DEFINITIONS}")
  endif ()
  
  if (${_target}_DEFINITIONS)
    target_compile_definitions(${_target} PRIVATE "${${_target}_DEFINITIONS}")
  endif ()
  
  if (${_target}_PUBLIC_LIBRARIES)
    target_link_libraries(${_target} PUBLIC "${${_target}_PUBLIC_LIBRARIES}")
  endif ()
  
  if (${_target}_LIBRARIES)
    target_link_libraries(${_target} PRIVATE "${${_target}_LIBRARIES}")
  endif ()
  
  if (${_target}_PUBLIC_FLAGS)
    target_compile_options(${_target} PUBLIC "${${_target}_PUBLIC_FLAGS}")
  endif ()
  
  if (${_target}_FLAGS)
    target_compile_options(${_target} PRIVATE "${${_target}_FLAGS}")
  endif ()
  
  if (${_target}_PUBLIC_HEADERS)
    set_target_properties(${_target} PROPERTIES PUBLIC_HEADER "${${_target}_PUBLIC_HEADERS}")
  endif ()

  set_target_properties(${_target} PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS OFF)
  list(APPEND ICU_TARGET_LIST ${_target})
endmacro ()

set(icudata_SOURCES
  stubdata/stubdata.cpp
  )

set(icudata_DATAFILES
  stubdata/Makefile.in
  stubdata/stubdata.vcxproj
  stubdata/stubdata.vcxproj.filters
  )

set(icudata_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/common"
  )

set(icudata_DEFINITIONS
  STUBDATA_BUILD
  )

set(icudata_FLAGS
  )
  
if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
  list(APPEND icudata_FLAGS -Wshadow -nodefaultlibs -nostdlib)
endif()

ICU_ADD_TARGET(icudata LIBRARY)

set(icuuc_PUBLIC_HEADERS
  common/unicode/appendable.h
  common/unicode/brkiter.h
  common/unicode/bytestream.h
  common/unicode/bytestrie.h
  common/unicode/bytestriebuilder.h
  common/unicode/caniter.h
  common/unicode/casemap.h
  common/unicode/char16ptr.h
  common/unicode/chariter.h
  common/unicode/dbbi.h
  common/unicode/docmain.h
  common/unicode/dtintrv.h
  common/unicode/edits.h
  common/unicode/enumset.h
  common/unicode/errorcode.h
  common/unicode/filteredbrk.h
  common/unicode/icudataver.h
  common/unicode/icuplug.h
  common/unicode/idna.h
  common/unicode/localebuilder.h
  common/unicode/localematcher.h
  common/unicode/localpointer.h
  common/unicode/locdspnm.h
  common/unicode/locid.h
  common/unicode/messagepattern.h
  common/unicode/normalizer2.h
  common/unicode/normlzr.h
  common/unicode/parseerr.h
  common/unicode/parsepos.h
  common/unicode/platform.h
  common/unicode/ptypes.h
  common/unicode/putil.h
  common/unicode/rbbi.h
  common/unicode/rep.h
  common/unicode/resbund.h
  common/unicode/schriter.h
  common/unicode/simpleformatter.h
  common/unicode/std_string.h
  common/unicode/strenum.h
  common/unicode/stringoptions.h
  common/unicode/stringpiece.h
  common/unicode/stringtriebuilder.h
  common/unicode/symtable.h
  common/unicode/ubidi.h
  common/unicode/ubiditransform.h
  common/unicode/ubrk.h
  common/unicode/ucasemap.h
  common/unicode/ucat.h
  common/unicode/uchar.h
  common/unicode/ucharstrie.h
  common/unicode/ucharstriebuilder.h
  common/unicode/uchriter.h
  common/unicode/uclean.h
  common/unicode/ucnv.h
  common/unicode/ucnvsel.h
  common/unicode/ucnv_cb.h
  common/unicode/ucnv_err.h
  common/unicode/uconfig.h
  common/unicode/ucpmap.h
  common/unicode/ucptrie.h
  common/unicode/ucurr.h
  common/unicode/udata.h
  common/unicode/udisplaycontext.h
  common/unicode/uenum.h
  common/unicode/uidna.h
  common/unicode/uiter.h
  common/unicode/uldnames.h
  common/unicode/uloc.h
  common/unicode/umachine.h
  common/unicode/umisc.h
  common/unicode/umutablecptrie.h
  common/unicode/unifilt.h
  common/unicode/unifunct.h
  common/unicode/unimatch.h
  common/unicode/uniset.h
  common/unicode/unistr.h
  common/unicode/unorm.h
  common/unicode/unorm2.h
  common/unicode/uobject.h
  common/unicode/urename.h
  common/unicode/urep.h
  common/unicode/ures.h
  common/unicode/uscript.h
  common/unicode/uset.h
  common/unicode/usetiter.h
  common/unicode/ushape.h
  common/unicode/usprep.h
  common/unicode/ustring.h
  common/unicode/ustringtrie.h
  common/unicode/utext.h
  common/unicode/utf.h
  common/unicode/utf16.h
  common/unicode/utf32.h
  common/unicode/utf8.h
  common/unicode/utf_old.h
  common/unicode/utrace.h
  common/unicode/utypes.h
  common/unicode/uvernum.h
  common/unicode/uversion.h
  )

set(icuuc_HEADERS
  common/bmpset.h
  common/brkeng.h
  common/bytesinkutil.h
  common/capi_helper.h
  common/charstr.h
  common/cmemory.h
  common/cpputils.h
  common/cstr.h
  common/cstring.h
  common/cwchar.h
  common/dictbe.h
  common/dictionarydata.h
  common/hash.h
  common/icuplugimp.h
  common/localeprioritylist.h
  common/localsvc.h
  common/locbased.h
  common/locdistance.h
  common/loclikelysubtags.h
  common/locmap.h
  common/locutil.h
  common/lsr.h
  common/messageimpl.h
  common/msvcres.h
  common/mutex.h
  common/norm2allmodes.h
  common/norm2_nfc_data.h
  common/normalizer2impl.h
  common/patternprops.h
  common/pluralmap.h
  common/propname.h
  common/propname_data.h
  common/propsvec.h
  common/punycode.h
  common/putilimp.h
  common/rbbidata.h
  common/rbbinode.h
  common/rbbirb.h
  common/rbbirpt.h
  common/rbbiscan.h
  common/rbbisetb.h
  common/rbbitblb.h
  common/rbbi_cache.h
  common/resource.h
  common/restrace.h
  common/ruleiter.h
  common/serv.h
  common/servloc.h
  common/servnotf.h
  common/sharedobject.h
  common/sprpimpl.h
  common/static_unicode_sets.h
  common/uarrsort.h
  common/uassert.h
  common/ubidiimp.h
  common/ubidi_props.h
  common/ubidi_props_data.h
  common/ubrkimpl.h
  common/ucase.h
  common/ucasemap_imp.h
  common/ucase_props_data.h
  common/uchar_props_data.h
  common/ucln.h
  common/ucln_cmn.h
  common/ucln_imp.h
  common/ucmndata.h
  common/ucnvmbcs.h
  common/ucnv_bld.h
  common/ucnv_cnv.h
  common/ucnv_ext.h
  common/ucnv_imp.h
  common/ucnv_io.h
  common/ucol_data.h
  common/ucol_swp.h
  common/ucptrie_impl.h
  common/ucurrimp.h
  common/udatamem.h
  common/udataswp.h
  common/uelement.h
  common/uenumimp.h
  common/uhash.h
  common/uinvchar.h
  common/ulayout_props.h
  common/ulist.h
  common/ulocimp.h
  common/umapfile.h
  common/umutex.h
  common/unifiedcache.h
  common/unisetspan.h
  common/unistrappender.h
  common/unormimp.h
  common/uposixdefs.h
  common/uprops.h
  common/uresdata.h
  common/uresimp.h
  common/ureslocs.h
  common/usc_impl.h
  common/uset_imp.h
  common/ustrenum.h
  common/ustrfmt.h
  common/ustr_cnv.h
  common/ustr_imp.h
  common/util.h
  common/utracimp.h
  common/utrie.h
  common/utrie2.h
  common/utrie2_impl.h
  common/utypeinfo.h
  common/uvector.h
  common/uvectr32.h
  common/uvectr64.h
  common/wintz.h
  )

set(icuuc_SOURCES
  common/appendable.cpp
  common/bmpset.cpp
  common/brkeng.cpp
  common/brkiter.cpp
  common/bytesinkutil.cpp
  common/bytestream.cpp
  common/bytestrie.cpp
  common/bytestriebuilder.cpp
  common/bytestrieiterator.cpp
  common/caniter.cpp
  common/characterproperties.cpp
  common/chariter.cpp
  common/charstr.cpp
  common/cmemory.cpp
  common/cstr.cpp
  common/cstring.cpp
  common/cwchar.cpp
  common/dictbe.cpp
  common/dictionarydata.cpp
  common/dtintrv.cpp
  common/edits.cpp
  common/errorcode.cpp
  common/filteredbrk.cpp
  common/filterednormalizer2.cpp
  common/icudataver.cpp
  common/icuplug.cpp
  common/loadednormalizer2impl.cpp
  common/localebuilder.cpp
  common/localematcher.cpp
  common/localeprioritylist.cpp
  common/locavailable.cpp
  common/locbased.cpp
  common/locdispnames.cpp
  common/locdistance.cpp
  common/locdspnm.cpp
  common/locid.cpp
  common/loclikely.cpp
  common/loclikelysubtags.cpp
  common/locmap.cpp
  common/locresdata.cpp
  common/locutil.cpp
  common/lsr.cpp
  common/messagepattern.cpp
  common/normalizer2.cpp
  common/normalizer2impl.cpp
  common/normlzr.cpp
  common/parsepos.cpp
  common/patternprops.cpp
  common/pluralmap.cpp
  common/propname.cpp
  common/propsvec.cpp
  common/punycode.cpp
  common/putil.cpp
  common/rbbi.cpp
  common/rbbidata.cpp
  common/rbbinode.cpp
  common/rbbirb.cpp
  common/rbbiscan.cpp
  common/rbbisetb.cpp
  common/rbbistbl.cpp
  common/rbbitblb.cpp
  common/rbbi_cache.cpp
  common/resbund.cpp
  common/resbund_cnv.cpp
  common/resource.cpp
  common/restrace.cpp
  common/ruleiter.cpp
  common/schriter.cpp
  common/serv.cpp
  common/servlk.cpp
  common/servlkf.cpp
  common/servls.cpp
  common/servnotf.cpp
  common/servrbf.cpp
  common/servslkf.cpp
  common/sharedobject.cpp
  common/simpleformatter.cpp
  common/static_unicode_sets.cpp
  common/stringpiece.cpp
  common/stringtriebuilder.cpp
  common/uarrsort.cpp
  common/ubidi.cpp
  common/ubidiln.cpp
  common/ubiditransform.cpp
  common/ubidiwrt.cpp
  common/ubidi_props.cpp
  common/ubrk.cpp
  common/ucase.cpp
  common/ucasemap.cpp
  common/ucasemap_titlecase_brkiter.cpp
  common/ucat.cpp
  common/uchar.cpp
  common/ucharstrie.cpp
  common/ucharstriebuilder.cpp
  common/ucharstrieiterator.cpp
  common/uchriter.cpp
  common/ucln_cmn.cpp
  common/ucmndata.cpp
  common/ucnv.cpp
  common/ucnv2022.cpp
  common/ucnvbocu.cpp
  common/ucnvdisp.cpp
  common/ucnvhz.cpp
  common/ucnvisci.cpp
  common/ucnvlat1.cpp
  common/ucnvmbcs.cpp
  common/ucnvscsu.cpp
  common/ucnvsel.cpp
  common/ucnv_bld.cpp
  common/ucnv_cb.cpp
  common/ucnv_cnv.cpp
  common/ucnv_ct.cpp
  common/ucnv_err.cpp
  common/ucnv_ext.cpp
  common/ucnv_io.cpp
  common/ucnv_lmb.cpp
  common/ucnv_set.cpp
  common/ucnv_u16.cpp
  common/ucnv_u32.cpp
  common/ucnv_u7.cpp
  common/ucnv_u8.cpp
  common/ucol_swp.cpp
  common/ucptrie.cpp
  common/ucurr.cpp
  common/udata.cpp
  common/udatamem.cpp
  common/udataswp.cpp
  common/uenum.cpp
  common/uhash.cpp
  common/uhash_us.cpp
  common/uidna.cpp
  common/uinit.cpp
  common/uinvchar.cpp
  common/uiter.cpp
  common/ulist.cpp
  common/uloc.cpp
  common/uloc_keytype.cpp
  common/uloc_tag.cpp
  common/umapfile.cpp
  common/umath.cpp
  common/umutablecptrie.cpp
  common/umutex.cpp
  common/unames.cpp
  common/unifiedcache.cpp
  common/unifilt.cpp
  common/unifunct.cpp
  common/uniset.cpp
  common/unisetspan.cpp
  common/uniset_closure.cpp
  common/uniset_props.cpp
  common/unistr.cpp
  common/unistr_case.cpp
  common/unistr_case_locale.cpp
  common/unistr_cnv.cpp
  common/unistr_props.cpp
  common/unistr_titlecase_brkiter.cpp
  common/unorm.cpp
  common/unormcmp.cpp
  common/uobject.cpp
  common/uprops.cpp
  common/uresbund.cpp
  common/uresdata.cpp
  common/ures_cnv.cpp
  common/uscript.cpp
  common/uscript_props.cpp
  common/usc_impl.cpp
  common/uset.cpp
  common/usetiter.cpp
  common/uset_props.cpp
  common/ushape.cpp
  common/usprep.cpp
  common/ustack.cpp
  common/ustrcase.cpp
  common/ustrcase_locale.cpp
  common/ustrenum.cpp
  common/ustrfmt.cpp
  common/ustring.cpp
  common/ustrtrns.cpp
  common/ustr_cnv.cpp
  common/ustr_titlecase_brkiter.cpp
  common/ustr_wcs.cpp
  common/utext.cpp
  common/utf_impl.cpp
  common/util.cpp
  common/util_props.cpp
  common/utrace.cpp
  common/utrie.cpp
  common/utrie2.cpp
  common/utrie2_builder.cpp
  common/utrie_swap.cpp
  common/uts46.cpp
  common/utypes.cpp
  common/uvector.cpp
  common/uvectr32.cpp
  common/uvectr64.cpp
  common/wintz.cpp
  )

set(icuuc_DATAFILES
  common/common.rc
  common/common.vcxproj
  common/common.vcxproj.filters
  common/common_uwp.vcxproj
  common/Makefile.in
  common/rbbicst.pl
  common/rbbirpt.txt
  )

set(icuuc_PUBLIC_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/common"
  )

set(icuuc_LIBRARIES
  ${CMAKE_DL_LIBS}
  icudata
  )

set(icuuc_DEFINITIONS
  U_COMMON_IMPLEMENTATION
  )

ICU_ADD_TARGET(icuuc LIBRARY)

set(icui18n_PUBLIC_HEADERS
  i18n/unicode/alphaindex.h
  i18n/unicode/basictz.h
  i18n/unicode/calendar.h
  i18n/unicode/choicfmt.h
  i18n/unicode/coleitr.h
  i18n/unicode/coll.h
  i18n/unicode/compactdecimalformat.h
  i18n/unicode/curramt.h
  i18n/unicode/currpinf.h
  i18n/unicode/currunit.h
  i18n/unicode/datefmt.h
  i18n/unicode/dcfmtsym.h
  i18n/unicode/decimfmt.h
  i18n/unicode/dtfmtsym.h
  i18n/unicode/dtitvfmt.h
  i18n/unicode/dtitvinf.h
  i18n/unicode/dtptngen.h
  i18n/unicode/dtrule.h
  i18n/unicode/fieldpos.h
  i18n/unicode/fmtable.h
  i18n/unicode/format.h
  i18n/unicode/formattedvalue.h
  i18n/unicode/fpositer.h
  i18n/unicode/gender.h
  i18n/unicode/gregocal.h
  i18n/unicode/listformatter.h
  i18n/unicode/measfmt.h
  i18n/unicode/measunit.h
  i18n/unicode/measure.h
  i18n/unicode/msgfmt.h
  i18n/unicode/nounit.h
  i18n/unicode/numberformatter.h
  i18n/unicode/numberrangeformatter.h
  i18n/unicode/numfmt.h
  i18n/unicode/numsys.h
  i18n/unicode/plurfmt.h
  i18n/unicode/plurrule.h
  i18n/unicode/rbnf.h
  i18n/unicode/rbtz.h
  i18n/unicode/regex.h
  i18n/unicode/region.h
  i18n/unicode/reldatefmt.h
  i18n/unicode/scientificnumberformatter.h
  i18n/unicode/search.h
  i18n/unicode/selfmt.h
  i18n/unicode/simpletz.h
  i18n/unicode/smpdtfmt.h
  i18n/unicode/sortkey.h
  i18n/unicode/stsearch.h
  i18n/unicode/tblcoll.h
  i18n/unicode/timezone.h
  i18n/unicode/tmunit.h
  i18n/unicode/tmutamt.h
  i18n/unicode/tmutfmt.h
  i18n/unicode/translit.h
  i18n/unicode/tzfmt.h
  i18n/unicode/tznames.h
  i18n/unicode/tzrule.h
  i18n/unicode/tztrans.h
  i18n/unicode/ucal.h
  i18n/unicode/ucol.h
  i18n/unicode/ucoleitr.h
  i18n/unicode/ucsdet.h
  i18n/unicode/udat.h
  i18n/unicode/udateintervalformat.h
  i18n/unicode/udatpg.h
  i18n/unicode/ufieldpositer.h
  i18n/unicode/uformattable.h
  i18n/unicode/uformattedvalue.h
  i18n/unicode/ugender.h
  i18n/unicode/ulistformatter.h
  i18n/unicode/ulocdata.h
  i18n/unicode/umsg.h
  i18n/unicode/unirepl.h
  i18n/unicode/unum.h
  i18n/unicode/unumberformatter.h
  i18n/unicode/unumsys.h
  i18n/unicode/upluralrules.h
  i18n/unicode/uregex.h
  i18n/unicode/uregion.h
  i18n/unicode/ureldatefmt.h
  i18n/unicode/usearch.h
  i18n/unicode/uspoof.h
  i18n/unicode/utmscale.h
  i18n/unicode/utrans.h
  i18n/unicode/vtzone.h
  )

set(icui18n_HEADERS
  i18n/anytrans.h
  i18n/astro.h
  i18n/bocsu.h
  i18n/brktrans.h
  i18n/buddhcal.h
  i18n/casetrn.h
  i18n/cecal.h
  i18n/chnsecal.h
  i18n/collation.h
  i18n/collationbuilder.h
  i18n/collationcompare.h
  i18n/collationdata.h
  i18n/collationdatabuilder.h
  i18n/collationdatareader.h
  i18n/collationdatawriter.h
  i18n/collationfastlatin.h
  i18n/collationfastlatinbuilder.h
  i18n/collationfcd.h
  i18n/collationiterator.h
  i18n/collationkeys.h
  i18n/collationroot.h
  i18n/collationrootelements.h
  i18n/collationruleparser.h
  i18n/collationsets.h
  i18n/collationsettings.h
  i18n/collationtailoring.h
  i18n/collationweights.h
  i18n/collunsafe.h
  i18n/coptccal.h
  i18n/cpdtrans.h
  i18n/csdetect.h
  i18n/csmatch.h
  i18n/csr2022.h
  i18n/csrecog.h
  i18n/csrmbcs.h
  i18n/csrsbcs.h
  i18n/csrucode.h
  i18n/csrutf8.h
  i18n/currfmt.h
  i18n/dangical.h
  i18n/dayperiodrules.h
  i18n/decContext.h
  i18n/decNumber.h
  i18n/decNumberLocal.h
  i18n/double-conversion-bignum-dtoa.h
  i18n/double-conversion-bignum.h
  i18n/double-conversion-cached-powers.h
  i18n/double-conversion-diy-fp.h
  i18n/double-conversion-double-to-string.h
  i18n/double-conversion-fast-dtoa.h
  i18n/double-conversion-ieee.h
  i18n/double-conversion-string-to-double.h
  i18n/double-conversion-strtod.h
  i18n/double-conversion-utils.h
  i18n/double-conversion.h
  i18n/dtitv_impl.h
  i18n/dtptngen_impl.h
  i18n/dt_impl.h
  i18n/erarules.h
  i18n/esctrn.h
  i18n/ethpccal.h
  i18n/fmtableimp.h
  i18n/formattedval_impl.h
  i18n/formatted_string_builder.h
  i18n/fphdlimp.h
  i18n/funcrepl.h
  i18n/gregoimp.h
  i18n/hebrwcal.h
  i18n/indiancal.h
  i18n/inputext.h
  i18n/islamcal.h
  i18n/japancal.h
  i18n/msgfmt_impl.h
  i18n/name2uni.h
  i18n/nfrlist.h
  i18n/nfrs.h
  i18n/nfrule.h
  i18n/nfsubs.h
  i18n/nortrans.h
  i18n/nultrans.h
  i18n/number_affixutils.h
  i18n/number_asformat.h
  i18n/number_compact.h
  i18n/number_currencysymbols.h
  i18n/number_decimalquantity.h
  i18n/number_decimfmtprops.h
  i18n/number_decnum.h
  i18n/number_formatimpl.h
  i18n/number_longnames.h
  i18n/number_mapper.h
  i18n/number_microprops.h
  i18n/number_modifiers.h
  i18n/number_multiplier.h
  i18n/number_patternmodifier.h
  i18n/number_patternstring.h
  i18n/number_roundingutils.h
  i18n/number_scientific.h
  i18n/number_skeletons.h
  i18n/number_types.h
  i18n/number_utils.h
  i18n/number_utypes.h
  i18n/numparse_affixes.h
  i18n/numparse_compositions.h
  i18n/numparse_currency.h
  i18n/numparse_decimal.h
  i18n/numparse_impl.h
  i18n/numparse_scientific.h
  i18n/numparse_symbols.h
  i18n/numparse_types.h
  i18n/numparse_utils.h
  i18n/numparse_validators.h
  i18n/numrange_impl.h
  i18n/numsys_impl.h
  i18n/olsontz.h
  i18n/persncal.h
  i18n/plurrule_impl.h
  i18n/quant.h
  i18n/quantityformatter.h
  i18n/rbt.h
  i18n/rbt_data.h
  i18n/rbt_pars.h
  i18n/rbt_rule.h
  i18n/rbt_set.h
  i18n/regexcmp.h
  i18n/regexcst.h
  i18n/regeximp.h
  i18n/regexst.h
  i18n/regextxt.h
  i18n/region_impl.h
  i18n/reldtfmt.h
  i18n/remtrans.h
  i18n/scriptset.h
  i18n/selfmtimpl.h
  i18n/sharedbreakiterator.h
  i18n/sharedcalendar.h
  i18n/shareddateformatsymbols.h
  i18n/sharednumberformat.h
  i18n/sharedpluralrules.h
  i18n/smpdtfst.h
  i18n/standardplural.h
  i18n/string_segment.h
  i18n/strmatch.h
  i18n/strrepl.h
  i18n/taiwncal.h
  i18n/titletrn.h
  i18n/tolowtrn.h
  i18n/toupptrn.h
  i18n/transreg.h
  i18n/tridpars.h
  i18n/tzgnames.h
  i18n/tznames_impl.h
  i18n/ucln_in.h
  i18n/ucol_imp.h
  i18n/uitercollationiterator.h
  i18n/umsg_imp.h
  i18n/unesctrn.h
  i18n/uni2name.h
  i18n/uspoof_conf.h
  i18n/uspoof_impl.h
  i18n/usrchimp.h
  i18n/utf16collationiterator.h
  i18n/utf8collationiterator.h
  i18n/vzone.h
  i18n/windtfmt.h
  i18n/winnmfmt.h
  i18n/wintzimpl.h
  i18n/zonemeta.h
  i18n/zrule.h
  i18n/ztrans.h
  )

set(icui18n_SOURCES
  i18n/alphaindex.cpp
  i18n/anytrans.cpp
  i18n/astro.cpp
  i18n/basictz.cpp
  i18n/bocsu.cpp
  i18n/brktrans.cpp
  i18n/buddhcal.cpp
  i18n/calendar.cpp
  i18n/casetrn.cpp
  i18n/cecal.cpp
  i18n/chnsecal.cpp
  i18n/choicfmt.cpp
  i18n/coleitr.cpp
  i18n/coll.cpp
  i18n/collation.cpp
  i18n/collationbuilder.cpp
  i18n/collationcompare.cpp
  i18n/collationdata.cpp
  i18n/collationdatabuilder.cpp
  i18n/collationdatareader.cpp
  i18n/collationdatawriter.cpp
  i18n/collationfastlatin.cpp
  i18n/collationfastlatinbuilder.cpp
  i18n/collationfcd.cpp
  i18n/collationiterator.cpp
  i18n/collationkeys.cpp
  i18n/collationroot.cpp
  i18n/collationrootelements.cpp
  i18n/collationruleparser.cpp
  i18n/collationsets.cpp
  i18n/collationsettings.cpp
  i18n/collationtailoring.cpp
  i18n/collationweights.cpp
  i18n/compactdecimalformat.cpp
  i18n/coptccal.cpp
  i18n/cpdtrans.cpp
  i18n/csdetect.cpp
  i18n/csmatch.cpp
  i18n/csr2022.cpp
  i18n/csrecog.cpp
  i18n/csrmbcs.cpp
  i18n/csrsbcs.cpp
  i18n/csrucode.cpp
  i18n/csrutf8.cpp
  i18n/curramt.cpp
  i18n/currfmt.cpp
  i18n/currpinf.cpp
  i18n/currunit.cpp
  i18n/dangical.cpp
  i18n/datefmt.cpp
  i18n/dayperiodrules.cpp
  i18n/dcfmtsym.cpp
  i18n/decContext.cpp
  i18n/decimfmt.cpp
  i18n/decNumber.cpp
  i18n/double-conversion-bignum-dtoa.cpp
  i18n/double-conversion-bignum.cpp
  i18n/double-conversion-cached-powers.cpp
  i18n/double-conversion-double-to-string.cpp
  i18n/double-conversion-fast-dtoa.cpp
  i18n/double-conversion-string-to-double.cpp
  i18n/double-conversion-strtod.cpp
  i18n/dtfmtsym.cpp
  i18n/dtitvfmt.cpp
  i18n/dtitvinf.cpp
  i18n/dtptngen.cpp
  i18n/dtrule.cpp
  i18n/erarules.cpp
  i18n/esctrn.cpp
  i18n/ethpccal.cpp
  i18n/fmtable.cpp
  i18n/fmtable_cnv.cpp
  i18n/format.cpp
  i18n/formattedvalue.cpp
  i18n/formattedval_iterimpl.cpp
  i18n/formattedval_sbimpl.cpp
  i18n/formatted_string_builder.cpp
  i18n/fphdlimp.cpp
  i18n/fpositer.cpp
  i18n/funcrepl.cpp
  i18n/gender.cpp
  i18n/gregocal.cpp
  i18n/gregoimp.cpp
  i18n/hebrwcal.cpp
  i18n/indiancal.cpp
  i18n/inputext.cpp
  i18n/islamcal.cpp
  i18n/japancal.cpp
  i18n/listformatter.cpp
  i18n/measfmt.cpp
  i18n/measunit.cpp
  i18n/measure.cpp
  i18n/msgfmt.cpp
  i18n/name2uni.cpp
  i18n/nfrs.cpp
  i18n/nfrule.cpp
  i18n/nfsubs.cpp
  i18n/nortrans.cpp
  i18n/nounit.cpp
  i18n/nultrans.cpp
  i18n/number_affixutils.cpp
  i18n/number_asformat.cpp
  i18n/number_capi.cpp
  i18n/number_compact.cpp
  i18n/number_currencysymbols.cpp
  i18n/number_decimalquantity.cpp
  i18n/number_decimfmtprops.cpp
  i18n/number_fluent.cpp
  i18n/number_formatimpl.cpp
  i18n/number_grouping.cpp
  i18n/number_integerwidth.cpp
  i18n/number_longnames.cpp
  i18n/number_mapper.cpp
  i18n/number_modifiers.cpp
  i18n/number_multiplier.cpp
  i18n/number_notation.cpp
  i18n/number_output.cpp
  i18n/number_padding.cpp
  i18n/number_patternmodifier.cpp
  i18n/number_patternstring.cpp
  i18n/number_rounding.cpp
  i18n/number_scientific.cpp
  i18n/number_skeletons.cpp
  i18n/number_utils.cpp
  i18n/numfmt.cpp
  i18n/numparse_affixes.cpp
  i18n/numparse_compositions.cpp
  i18n/numparse_currency.cpp
  i18n/numparse_decimal.cpp
  i18n/numparse_impl.cpp
  i18n/numparse_parsednumber.cpp
  i18n/numparse_scientific.cpp
  i18n/numparse_symbols.cpp
  i18n/numparse_validators.cpp
  i18n/numrange_fluent.cpp
  i18n/numrange_impl.cpp
  i18n/numsys.cpp
  i18n/olsontz.cpp
  i18n/persncal.cpp
  i18n/plurfmt.cpp
  i18n/plurrule.cpp
  i18n/quant.cpp
  i18n/quantityformatter.cpp
  i18n/rbnf.cpp
  i18n/rbt.cpp
  i18n/rbtz.cpp
  i18n/rbt_data.cpp
  i18n/rbt_pars.cpp
  i18n/rbt_rule.cpp
  i18n/rbt_set.cpp
  i18n/regexcmp.cpp
  i18n/regeximp.cpp
  i18n/regexst.cpp
  i18n/regextxt.cpp
  i18n/region.cpp
  i18n/reldatefmt.cpp
  i18n/reldtfmt.cpp
  i18n/rematch.cpp
  i18n/remtrans.cpp
  i18n/repattrn.cpp
  i18n/rulebasedcollator.cpp
  i18n/scientificnumberformatter.cpp
  i18n/scriptset.cpp
  i18n/search.cpp
  i18n/selfmt.cpp
  i18n/sharedbreakiterator.cpp
  i18n/simpletz.cpp
  i18n/smpdtfmt.cpp
  i18n/smpdtfst.cpp
  i18n/sortkey.cpp
  i18n/standardplural.cpp
  i18n/string_segment.cpp
  i18n/strmatch.cpp
  i18n/strrepl.cpp
  i18n/stsearch.cpp
  i18n/taiwncal.cpp
  i18n/timezone.cpp
  i18n/titletrn.cpp
  i18n/tmunit.cpp
  i18n/tmutamt.cpp
  i18n/tmutfmt.cpp
  i18n/tolowtrn.cpp
  i18n/toupptrn.cpp
  i18n/translit.cpp
  i18n/transreg.cpp
  i18n/tridpars.cpp
  i18n/tzfmt.cpp
  i18n/tzgnames.cpp
  i18n/tznames.cpp
  i18n/tznames_impl.cpp
  i18n/tzrule.cpp
  i18n/tztrans.cpp
  i18n/ucal.cpp
  i18n/ucln_in.cpp
  i18n/ucol.cpp
  i18n/ucoleitr.cpp
  i18n/ucol_res.cpp
  i18n/ucol_sit.cpp
  i18n/ucsdet.cpp
  i18n/udat.cpp
  i18n/udateintervalformat.cpp
  i18n/udatpg.cpp
  i18n/ufieldpositer.cpp
  i18n/uitercollationiterator.cpp
  i18n/ulistformatter.cpp
  i18n/ulocdata.cpp
  i18n/umsg.cpp
  i18n/unesctrn.cpp
  i18n/uni2name.cpp
  i18n/unum.cpp
  i18n/unumsys.cpp
  i18n/upluralrules.cpp
  i18n/uregex.cpp
  i18n/uregexc.cpp
  i18n/uregion.cpp
  i18n/usearch.cpp
  i18n/uspoof.cpp
  i18n/uspoof_build.cpp
  i18n/uspoof_conf.cpp
  i18n/uspoof_impl.cpp
  i18n/utf16collationiterator.cpp
  i18n/utf8collationiterator.cpp
  i18n/utmscale.cpp
  i18n/utrans.cpp
  i18n/vtzone.cpp
  i18n/vzone.cpp
  i18n/windtfmt.cpp
  i18n/winnmfmt.cpp
  i18n/wintzimpl.cpp
  i18n/zonemeta.cpp
  i18n/zrule.cpp
  i18n/ztrans.cpp
  )

set(icui18n_DATAFILES
  i18n/i18n.rc
  i18n/i18n.vcxproj
  i18n/i18n.vcxproj.filters
  i18n/i18n_uwp.vcxproj
  i18n/Makefile.in
  i18n/regexcst.pl
  i18n/regexcst.txt
  )
   
set(icui18n_PUBLIC_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/i18n"
  )

set(icui18n_PUBLIC_LIBRARIES
  icuuc
  )

set(icui18n_DEFINITIONS
  U_I18N_IMPLEMENTATION
  )
  
ICU_ADD_TARGET(icui18n LIBRARY)

set(icuio_PUBLIC_HEADERS
  io/unicode/ustdio.h
  io/unicode/ustream.h
  )

set(icuio_HEADERS
  io/locbund.h
  io/ucln_io.h
  io/ufile.h
  io/ufmt_cmn.h
  io/uprintf.h
  io/uscanf.h
  )

set(icuio_SOURCES
  io/locbund.cpp
  io/sprintf.cpp
  io/sscanf.cpp
  io/ucln_io.cpp
  io/ufile.cpp
  io/ufmt_cmn.cpp
  io/uprintf.cpp
  io/uprntf_p.cpp
  io/uscanf.cpp
  io/uscanf_p.cpp
  io/ustdio.cpp
  io/ustream.cpp
  )

set(icuio_DATAFILES
  io/io.rc
  io/io.vcxproj
  io/io.vcxproj.filters
  io/Makefile.in
  )
   
set(icuio_PUBLIC_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/io"
  )

set(icuio_PUBLIC_LIBRARIES
  icui18n
  )

set(icuio_DEFINITIONS
  U_IO_IMPLEMENTATION
  )
  
ICU_ADD_TARGET(icuio LIBRARY)

set(icutu_HEADERS
  tools/toolutil/collationinfo.h
  tools/toolutil/dbgutil.h
  tools/toolutil/denseranges.h
  tools/toolutil/filestrm.h
  tools/toolutil/filetools.h
  tools/toolutil/flagparser.h
  tools/toolutil/package.h
  tools/toolutil/pkg_genc.h
  tools/toolutil/pkg_gencmn.h
  tools/toolutil/pkg_icu.h
  tools/toolutil/pkg_imp.h
  tools/toolutil/ppucd.h
  tools/toolutil/swapimpl.h
  tools/toolutil/toolutil.h
  tools/toolutil/ucbuf.h
  tools/toolutil/ucm.h
  tools/toolutil/udbgutil.h
  tools/toolutil/unewdata.h
  tools/toolutil/uoptions.h
  tools/toolutil/uparse.h
  tools/toolutil/writesrc.h
  tools/toolutil/xmlparser.h
  )

set(icutu_SOURCES
  tools/toolutil/collationinfo.cpp
  tools/toolutil/dbgutil.cpp
  tools/toolutil/denseranges.cpp
  tools/toolutil/filestrm.cpp
  tools/toolutil/filetools.cpp
  tools/toolutil/flagparser.cpp
  tools/toolutil/package.cpp
  tools/toolutil/pkgitems.cpp
  tools/toolutil/pkg_genc.cpp
  tools/toolutil/pkg_gencmn.cpp
  tools/toolutil/pkg_icu.cpp
  tools/toolutil/ppucd.cpp
  tools/toolutil/swapimpl.cpp
  tools/toolutil/toolutil.cpp
  tools/toolutil/ucbuf.cpp
  tools/toolutil/ucln_tu.cpp
  tools/toolutil/ucm.cpp
  tools/toolutil/ucmstate.cpp
  tools/toolutil/udbgutil.cpp
  tools/toolutil/unewdata.cpp
  tools/toolutil/uoptions.cpp
  tools/toolutil/uparse.cpp
  tools/toolutil/writesrc.cpp
  tools/toolutil/xmlparser.cpp
  )

set(icutu_DATAFILES
  tools/toolutil/Makefile.in
  tools/toolutil/toolutil.vcxproj
  )
   
set(icutu_PUBLIC_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/tools/toolutil"
  )

set(icutu_PUBLIC_LIBRARIES
  icui18n
  )

set(icutu_DEFINITIONS
  U_TOOLUTIL_IMPLEMENTATION
  )
  
ICU_ADD_TARGET(icutu LIBRARY)

set(icutest_HEADERS
  tools/ctestfw/unicode/ctest.h
  tools/ctestfw/unicode/datamap.h
  tools/ctestfw/unicode/testdata.h
  tools/ctestfw/unicode/testlog.h
  tools/ctestfw/unicode/testtype.h
  tools/ctestfw/unicode/tstdtmod.h
  tools/ctestfw/unicode/uperf.h
  tools/ctestfw/unicode/utimer.h
  )

set(icutest_SOURCES
  tools/ctestfw/ctest.c
  tools/ctestfw/datamap.cpp
  tools/ctestfw/testdata.cpp
  tools/ctestfw/tstdtmod.cpp
  tools/ctestfw/ucln_ct.c
  tools/ctestfw/uperf.cpp
  )

set(icutest_DATAFILES
  tools/ctestfw/Makefile.in
  tools/ctestfw/ctestfw.vcxproj
  tools/ctestfw/ctestfw.vcxproj.filters
  )
   
set(icutest_PUBLIC_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/tools/ctestfw"
  )

set(icutest_PUBLIC_LIBRARIES
  icutu
  )

set(icutest_DEFINITIONS
  T_CTEST_IMPLEMENTATION
  )
  
ICU_ADD_TARGET(icutest LIBRARY)

set(makeconv_HEADERS
  tools/makeconv/genmbcs.h
  tools/makeconv/makeconv.h
  )

set(makeconv_SOURCES
  tools/makeconv/gencnvex.c
  tools/makeconv/genmbcs.cpp
  tools/makeconv/makeconv.cpp
  tools/makeconv/ucnvstat.c
  )

set(makeconv_DATAFILES
  tools/makeconv/makeconv.1.in
  tools/makeconv/makeconv.vcxproj
  tools/makeconv/makeconv.vcxproj.filters
  tools/makeconv/Makefile.in
  )

set(makeconv_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/tools/makeconv"
  )

set(makeconv_LIBRARIES
  icutu
  )

ICU_ADD_TARGET(makeconv EXECUTABLE)

set(genrb_HEADERS
  tools/genrb/errmsg.h
  tools/genrb/filterrb.h
  tools/genrb/genrb.h
  tools/genrb/parse.h
  tools/genrb/prscmnts.h
  tools/genrb/rbutil.h
  tools/genrb/read.h
  tools/genrb/reslist.h
  tools/genrb/rle.h
  tools/genrb/ustr.h
  )

set(genrb_SOURCES
  tools/genrb/errmsg.c
  tools/genrb/filterrb.cpp
  tools/genrb/genrb.cpp
  tools/genrb/parse.cpp
  tools/genrb/prscmnts.cpp
  tools/genrb/rbutil.c
  tools/genrb/read.c
  tools/genrb/reslist.cpp
  tools/genrb/rle.c
  tools/genrb/ustr.c
  tools/genrb/wrtjava.cpp
  tools/genrb/wrtxml.cpp
  )

set(genrb_DATAFILES
  tools/genrb/genrb.1.in
  tools/genrb/genrb.vcxproj
  tools/genrb/genrb.vcxproj.filters
  tools/genrb/Makefile.in
  )

set(genrb_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/tools/genrb"
  )

set(genrb_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(genrb EXECUTABLE)

set(derb_SOURCES
  tools/genrb/derb.cpp
  )

set(derb_DATAFILES
  tools/genrb/derb.1.in
  tools/genrb/derb.vcxproj
  tools/genrb/derb.vcxproj.filters
  )

set(derb_LIBRARIES
  icuio
  icutu
  )
  
ICU_ADD_TARGET(derb EXECUTABLE)

set(genbrk_SOURCES
  tools/genbrk/genbrk.cpp
  )

set(genbrk_DATAFILES
  tools/genbrk/genbrk.1.in
  tools/genbrk/genbrk.vcxproj
  tools/genbrk/genbrk.vcxproj.filters
  tools/genbrk/Makefile.in
  )

set(genbrk_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(genbrk EXECUTABLE)

set(gencnval_SOURCES
  tools/gencnval/gencnval.c
  )

set(gencnval_DATAFILES
  tools/gencnval/gencnval.1.in
  tools/gencnval/gencnval.vcxproj
  tools/gencnval/gencnval.vcxproj.filters
  tools/gencnval/Makefile.in
  )

set(gencnval_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(gencnval EXECUTABLE)

set(gensprep_HEADERS
  tools/gensprep/gensprep.h
  )

set(gensprep_SOURCES
  tools/gensprep/gensprep.c
  tools/gensprep/store.c
  )

set(gensprep_DATAFILES
  tools/gensprep/filterRFC3454.pl
  tools/gensprep/gensprep.8.in
  tools/gensprep/gensprep.vcxproj
  tools/gensprep/gensprep.vcxproj.filters
  tools/gensprep/Makefile.in
  )

set(gensprep_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/tools/gensprep"
  )

set(gensprep_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(gensprep EXECUTABLE)

set(icuinfo_SOURCES
  tools/icuinfo/icuinfo.cpp
  tools/icuinfo/testplug.c
  )

set(icuinfo_DATAFILES
  tools/icuinfo/icuinfo.vcxproj
  tools/icuinfo/icuplugins_windows_sample.txt
  tools/icuinfo/Makefile.in
  tools/icuinfo/testplug.vcxproj
  tools/icuinfo/testplug.vcxproj.filters
  )

set(icuinfo_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(icuinfo EXECUTABLE)

set(genccode_SOURCES
  tools/genccode/genccode.c
  )

set(genccode_DATAFILES
  tools/genccode/genccode.8.in
  tools/genccode/genccode.vcxproj
  tools/genccode/genccode.vcxproj.filters
  tools/genccode/Makefile.in
  )

set(genccode_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(genccode EXECUTABLE)

set(gencmn_SOURCES
  tools/gencmn/gencmn.c
  )

set(gencmn_DATAFILES
  tools/gencmn/gencmn.8.in
  tools/gencmn/gencmn.vcxproj
  tools/gencmn/gencmn.vcxproj.filters
  tools/gencmn/Makefile.in
  )

set(gencmn_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(gencmn EXECUTABLE)

set(icupkg_SOURCES
  tools/icupkg/icupkg.cpp
  )

set(icupkg_DATAFILES
  tools/icupkg/icupkg.8.in
  tools/icupkg/icupkg.vcxproj
  tools/icupkg/Makefile.in
  )

set(icupkg_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(icupkg EXECUTABLE)

set(pkgdata_HEADERS
  tools/pkgdata/pkgtypes.h
  )

set(pkgdata_SOURCES
  tools/pkgdata/pkgdata.cpp
  tools/pkgdata/pkgtypes.c
  )

set(pkgdata_DATAFILES
  tools/pkgdata/Makefile.in
  tools/pkgdata/pkgdata.1.in
  tools/pkgdata/pkgdata.vcxproj
  tools/pkgdata/pkgdata.vcxproj.filters
  )

set(pkgdata_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/tools/pkgdata"
  )

set(pkgdata_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(pkgdata EXECUTABLE)

set(gentest_HEADERS
  tools/gentest/gentest.h
  )

set(gentest_SOURCES
  tools/gentest/genres32.c
  tools/gentest/gentest.c
  )

set(gentest_DATAFILES
  tools/gentest/gentest.vcxproj
  tools/gentest/gentest.vcxproj.filters
  tools/gentest/Makefile.in
  )

set(gentest_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/tools/gentest"
  )

set(gentest_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(gentest EXECUTABLE)

set(gennorm2_HEADERS
  tools/gennorm2/extradata.h
  tools/gennorm2/n2builder.h
  tools/gennorm2/norms.h
  )

set(gennorm2_SOURCES
  tools/gennorm2/extradata.cpp
  tools/gennorm2/gennorm2.cpp
  tools/gennorm2/n2builder.cpp
  tools/gennorm2/norms.cpp
  )

set(gennorm2_DATAFILES
  tools/gennorm2/gennorm2.vcxproj
  tools/gennorm2/Makefile.in
  )

set(gennorm2_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/tools/gennorm2"
  )

set(gennorm2_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(gennorm2 EXECUTABLE)

set(gencfu_SOURCES
  tools/gencfu/gencfu.cpp
  )

set(gencfu_DATAFILES
  tools/gencfu/gencfu.1.in
  tools/gencfu/gencfu.vcxproj
  tools/gencfu/gencfu.vcxproj.filters
  tools/gencfu/Makefile.in
  )

set(gencfu_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(gencfu EXECUTABLE)

set(gendict_SOURCES
  tools/gendict/gendict.cpp
  )

set(gendict_DATAFILES
  tools/gendict/gendict.1.in
  tools/gendict/gendict.vcxproj
  tools/gendict/gendict.vcxproj.filters
  tools/gendict/Makefile.in
  )

set(gendict_LIBRARIES
  icutu
  )
  
ICU_ADD_TARGET(gendict EXECUTABLE)

set(escapesrc_HEADERS
  tools/escapesrc/cptbl.h
  )

set(escapesrc_SOURCES
  tools/escapesrc/escapesrc.cpp
  )

set(escapesrc_DATAFILES
  tools/escapesrc/Makefile.in
  )

set(escapesrc_INCLUDES
  "${CMAKE_CURRENT_SOURCE_DIR}/tools/escapesrc"
  )

set(escapesrc_LIBRARIES
  icuuc
  )
  
ICU_ADD_TARGET(escapesrc EXECUTABLE)

install(TARGETS ${ICU_TARGET_LIST}
  RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/unicode"
  )
 