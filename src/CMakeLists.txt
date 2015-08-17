add_library(inverter inverter.cpp)

add_executable(testInverter test_inverter.cpp)
target_link_libraries(testInverter inverter)
