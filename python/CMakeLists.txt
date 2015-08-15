find_package(PythonInterp REQUIRED)
execute_process(COMMAND
    ${PYTHON_EXECUTABLE} -c "import sys; sys.stdout.write(sys.version[:3])"
    OUTPUT_VARIABLE PYVERSION)

if(APPLE)
	# Overload the PYTHON_INCLUDE_DIR because, on OSX with a homebrew-provided python, cmake latches on to an old Apple-provided python install. 
	execute_process(COMMAND python-config --prefix
		OUTPUT_VARIABLE PYTHON_PREFIX
		OUTPUT_STRIP_TRAILING_WHITESPACE
		)
	set(PYTHON_INCLUDE_DIR ${PYTHON_PREFIX}/include/python${PYVERSION})
	set(PYTHON_LIBRARY ${PYTHON_PREFIX}/lib/libpython${PYVERSION}.dylib)
endif()

find_package(SWIG REQUIRED)
include(UseSWIG)

find_package(NumPy REQUIRED)
include_directories(${NUMPY_INCLUDE_DIRS})

find_package( PythonLibs REQUIRED )
include_directories( ${PYTHON_INCLUDE_DIRS} )
include_directories( ${CMAKE_CURRENT_SOURCE_DIR}/../src )

set_source_files_properties(inverter_wrapper.i PROPERTIES CPLUSPLUS ON)
set(CMAKE_SWIG_FLAGS "-I${CMAKE_CURRENT_SOURCE_DIR}/../swig")
swig_add_module(inverter_wrapper python ${CMAKE_CURRENT_SOURCE_DIR}/inverter_wrapper.i)
swig_link_libraries(inverter_wrapper inverter ${PYTHON_LIBRARIES})
install(TARGETS ${SWIG_MODULE_inverter_wrapper_REAL_NAME} 
	    DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/pyinverter)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/inverter_wrapper.py 
	    DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/pyinverter)
