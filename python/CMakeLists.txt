# Configure and build our SWIG-based python wrapper.
#
# To do that, we have to first find the correct headers and libraries for python:

# Find python and get its version number
find_package(PythonInterp REQUIRED)
set(PYVERSION "${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}")

if(APPLE)
	# Overload the PYTHON_INCLUDE_DIR and PYTHON_LIBRARY because, on OSX with a homebrew-provided python, cmake latches on to an old Apple-provided python install. 
	execute_process(COMMAND python${PYTHON_VERSION_MAJOR}-config --prefix
		OUTPUT_VARIABLE PYTHON_PREFIX
		OUTPUT_STRIP_TRAILING_WHITESPACE
		)
	if (PYTHON_VERSION_MAJOR GREATER 2)
		set(PYTHON_INCLUDE_DIR ${PYTHON_PREFIX}/include/python${PYVERSION}m)
	else()
		set(PYTHON_INCLUDE_DIR ${PYTHON_PREFIX}/include/python${PYVERSION})
	endif()

	set(PYTHON_LIBRARY ${PYTHON_PREFIX}/lib/libpython${PYVERSION}.dylib)
	# These variable settings will affect the behavior of find_package(PythonLibs)
endif()

# Load the swig macros
find_package(SWIG REQUIRED)
include(UseSWIG)

# Find the numpy header paths and include them. This calls the cmake/FindNumPy.cmake file included in this repo. 
find_package(NumPy REQUIRED)
include_directories(${NUMPY_INCLUDE_DIRS})

# Find the python libraries so that we can link against them.
find_package( PythonLibs REQUIRED )
include_directories( ${PYTHON_INCLUDE_DIRS} )
include_directories( ${CMAKE_CURRENT_SOURCE_DIR}/../src )

# Tell SWIG that we're compiling a c++ (not c) file, and tell it to use python3 if appropriate. 
if (PYTHON_VERSION_MAJOR GREATER 2)
	set_source_files_properties(inverter_wrapper.i PROPERTIES
		CPLUSPLUS ON
		SWIG_FLAGS "-py3"
		)
else()
	set_source_files_properties(inverter_wrapper.i PROPERTIES 
		CPLUSPLUS ON)
endif()

# Tell swig to also look for interface (.i) files in ../swig/
set(CMAKE_SWIG_FLAGS "-I${CMAKE_CURRENT_SOURCE_DIR}/../swig")

# Tell swig to build python bindings based on inverter_wrapper.i and link them against our inverter library
swig_add_module(inverter_wrapper python ${CMAKE_CURRENT_SOURCE_DIR}/inverter_wrapper.i)
swig_link_libraries(inverter_wrapper inverter ${PYTHON_LIBRARIES})

# If we wanted to, we could copy all the python source files to an install directory like /usr/local/lib/python2.7/site-packages
# Instead, we're just going to keep the python files where they are and install the module that swig generates right next to them. 
install(TARGETS ${SWIG_MODULE_inverter_wrapper_REAL_NAME} 
	    DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/pyinverter)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/inverter_wrapper.py 
	    DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/pyinverter)
