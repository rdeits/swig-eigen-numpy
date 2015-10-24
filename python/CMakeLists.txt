# Configure and build our SWIG-based python wrapper.

# We defined a helper function in swigmake/cmake/SwigPython.cmake
include(SwigPython)
add_swig_python_module(TARGET inverter_wrapper
                       CPLUSPLUS
                       SWIG_I_FILE ${CMAKE_CURRENT_SOURCE_DIR}/inverter_wrapper.i
                       INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/../src
                       LINK_LIBRARIES inverter
                       SWIG_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/../swigmake/swig/python
                       DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/pyinverter)
# If we wanted to, we could copy all the python source files to an install directory like /usr/local/lib/python2.7/site-packages
# Instead, we're just going to keep the python files where they are and install the module that swig generates right next to them. 


add_swig_python_module(TARGET autodiff
                       CPLUSPLUS
                       SWIG_I_FILE ${CMAKE_CURRENT_SOURCE_DIR}/autodiff.i
                       INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/../src
                       SWIG_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/../swigmake/swig/python
                       DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/pyad)