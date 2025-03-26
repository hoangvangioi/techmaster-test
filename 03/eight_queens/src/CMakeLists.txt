# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(eight_queens_library VERSION 0.0.1 LANGUAGES C)

add_library(eight_queens SHARED
  "eight_queens.c"
)

set_target_properties(eight_queens PROPERTIES
  PUBLIC_HEADER eight_queens.h
  OUTPUT_NAME "eight_queens"
)

target_compile_definitions(eight_queens PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(eight_queens PRIVATE "-Wl,-z,max-page-size=16384")
endif()
