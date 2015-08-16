cmake_minimum_required(VERSION 2.8.0)
# include(ExternalProject)

if(APPLE)
  cmake_policy(SET CMP0042 NEW)
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

find_package( Eigen3 )
if (EIGEN3_FOUND)
  include_directories( ${EIGEN3_INCLUDE_DIR} )
  message("EIGEN3_INCLUDE_DIR: " ${EIGEN3_INCLUDE_DIR})
else()
  message(FATAL_ERROR "Could not find eigen, which is a required depedency")
endif()


add_subdirectory(src)
add_subdirectory(python)
