#
# Original Source: https://github.com/floooh/fbxc/blob/master/cmake/find_fbxsdk.cmake
# Modified to use /MD and pick up XML & Zlib dependency of newer SDKs
# 
# Helper function for finding the FBX SDK.
#
# sets: FBXSDK_FOUND, 
#       FBXSDK_DIR, 
#       FBXSDK_INCLUDE_DIR
#       FBXSDK_LIBS
#       FBXSDK_LIBS_DEBUG
#
set(_fbxsdk_version "2020.2")
set(_fbxsdk_vstudio_version "vs2019")

message("Looking for FBX SDK version: ${_fbxsdk_version}")

if (APPLE)
    set(_fbxsdk_approot "${CMAKE_SOURCE_DIR}/sdk/Darwin")
    set(_fbxsdk_libdir_debug "lib/clang/debug")
    set(_fbxsdk_libdir_release "lib/clang/release")
    set(_fbxsdk_libname_debug "libfbxsdk.a")
    set(_fbxsdk_libname_release "libfbxsdk.a")
    set(_xml2_libname_debug "libxml2.a")
    set(_xml2_libname_release "libxml2.a")
    set(_zlib_libname_debug "libzlib.a")
    set(_zlib_libname_release "libzlib.a")
elseif (WIN32)
    # the $ENV{PROGRAMFILES} variable doesn't really work since there's no 
    # 64-bit cmake version
    set(_fbxsdk_approot "${CMAKE_SOURCE_DIR}/sdk/Windows")
    set(_fbxsdk_libdir_debug "lib/${_fbxsdk_vstudio_version}/x64/debug")
    set(_fbxsdk_libdir_release "lib/${_fbxsdk_vstudio_version}/x64/release")
    set(_fbxsdk_libname_debug "libfbxsdk-md.lib")
    set(_fbxsdk_libname_release "libfbxsdk-md.lib")
    set(_xml2_libname_debug "libxml2-md.lib")
    set(_xml2_libname_release "libxml2-md.lib")
    set(_zlib_libname_debug "zlib-md.lib")
    set(_zlib_libname_release "zlib-md.lib")
elseif (UNIX)
    set(_fbxsdk_version "2019.2")
    set(_fbxsdk_approot "${CMAKE_SOURCE_DIR}/sdk/Linux")
    set(_fbxsdk_libdir_debug "lib/gcc/debug")
    set(_fbxsdk_libdir_release "lib/gcc/release")
    set(_fbxsdk_libname_debug "libfbxsdk.so")
    set(_fbxsdk_libname_release "libfbxsdk.so")
    set(_xml2_libname_debug "libxml2.so")
    set(_xml2_libname_release "libxml2.so")
    set(_zlib_libname_debug "libz.so")
    set(_zlib_libname_release "libz.so")
else ()
    message(FATAL_ERROR "FIXME: find FBX SDK on unknown platform")
endif()

# should point the the FBX SDK installation dir
set(_fbxsdk_root "${_fbxsdk_approot}/${_fbxsdk_version}")
message("_fbxsdk_root: ${_fbxsdk_root}")

# find header dir and libs
find_path(FBXSDK_INCLUDE_DIR "fbxsdk.h" 
          PATHS ${_fbxsdk_root} "${CMAKE_SOURCE_DIR}/sdk/include"
          PATH_SUFFIXES "include")
message("FBXSDK_INCLUDE_DIR: ${FBXSDK_INCLUDE_DIR}")
find_library(FBXSDK_LIBRARY ${_fbxsdk_libname_release}
             PATHS ${_fbxsdk_root} "${CMAKE_SOURCE_DIR}/sdk/lib"
             PATH_SUFFIXES ${_fbxsdk_libdir_release})
message("FBXSDK_LIBRARY: ${FBXSDK_LIBRARY}")
find_library(FBXSDK_LIBRARY_DEBUG ${_fbxsdk_libname_debug}
             PATHS ${_fbxsdk_root} "${CMAKE_SOURCE_DIR}/sdk/lib"
             PATH_SUFFIXES ${_fbxsdk_libdir_debug})
message("FBXSDK_LIBRARY_DEBUG: ${FBXSDK_LIBRARY_DEBUG}")

find_library(XML2_LIBRARY ${_xml2_libname_release}
             PATHS ${_fbxsdk_root} "${CMAKE_SOURCE_DIR}/sdk/lib"
             PATH_SUFFIXES ${_fbxsdk_libdir_release})
message("XML2_LIBRARY: ${XML2_LIBRARY}")
find_library(XML2_LIBRARY_DEBUG ${_xml2_libname_debug}
             PATHS ${_fbxsdk_root} "${CMAKE_SOURCE_DIR}/sdk/lib"
             PATH_SUFFIXES ${_fbxsdk_libdir_debug})
message("XML2_LIBRARY_DEBUG: ${XML2_LIBRARY_DEBUG}")

find_library(ZLIB_LIBRARY ${_zlib_libname_release}
             PATHS ${_fbxsdk_root} "${CMAKE_SOURCE_DIR}/sdk/lib"
             PATH_SUFFIXES ${_fbxsdk_libdir_release})
message("ZIB_LIBRARY: ${ZLIB_LIBRARY}")
find_library(ZLIB_LIBRARY_DEBUG ${_zlib_libname_debug}
             PATHS ${_fbxsdk_root} "${CMAKE_SOURCE_DIR}/sdk/lib"
             PATH_SUFFIXES ${_fbxsdk_libdir_debug})
message("ZLIB_LIBRARY_DEBUG: ${ZLIB_LIBRARY_DEBUG}")

if (FBXSDK_INCLUDE_DIR AND FBXSDK_LIBRARY AND FBXSDK_LIBRARY_DEBUG)
    set(FBXSDK_FOUND YES)
    set(FBXSDK_LIBS ${FBXSDK_LIBRARY} ${XML2_LIBRARY} ${ZLIB_LIBRARY})
    set(FBXSDK_LIBS_DEBUG ${FBXSDK_LIBRARY_DEBUG} ${XML2_LIBRARY_DEBUG} ${ZLIB_LIBRARY_DEBUG})
    set(FBXSDK_DIR ${_fbxsdk_root})
else()
    set(FBXSDK_FOUND NO)
endif()
