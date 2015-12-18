cmake_minimum_required(VERSION 2.8.0)

if(APPLE)
  cmake_policy(SET CMP0042 NEW)
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/swigmake/cmake)

find_package( Eigen3 )
if (EIGEN3_FOUND)
  include_directories( ${EIGEN3_INCLUDE_DIR} )
else()
    message("Eigen3 not found, so I'm installing it from source. ")
	include(ExternalProject)
	ExternalProject_Add(eigen-pod
		GIT_REPOSITORY https://github.com/RobotLocomotion/eigen-pod.git
		GIT_TAG ceba39500b89a77a8649b3e8b421b10a3d74d42b
		BUILD_IN_SOURCE 1
		CONFIGURE_COMMAND ""
		BUILD_COMMAND make BUILD_PREFIX=${CMAKE_INSTALL_PREFIX} BUILD_TYPE=${CMAKE_BUILD_TYPE}
		UPDATE_COMMAND ""
		INSTALL_COMMAND ""
		)
	include_directories(${CMAKE_INSTALL_PREFIX}/include/eigen3)
endif()


add_subdirectory(src)
add_subdirectory(python)
