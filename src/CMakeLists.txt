add_library(inverter SHARED inverter.cpp)
install(TARGETS inverter DESTINATION lib)

add_executable(testInverter test_inverter.cpp)
target_link_libraries(testInverter inverter)
