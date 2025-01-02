cmake_minimum_required (VERSION 2.28)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "In-source builds are not allowed.
  cmake -B build")
endif()

project (hello)

# patch files
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/include/value.h
  COMMAND ${CMAKE_COMMAND}
    -Din:FILEPATH=${CMAKE_CURRENT_SOURCE_DIR}/include/value.h
    -Dout:FILEPATH=${CMAKE_CURRENT_BINARY_DIR}/include/value.h
    -Dpatch:FILEPATH=${CMAKE_CURRENT_SOURCE_DIR}/value.h.patch
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/PatchFile.cmake
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)


add_subdirectory (hello)
add_subdirectory (demo)

add_library (Hello hello.cxx)

target_include_directories (hello PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(hello BEFORE PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/include)

add_executable (helloDemo demo.cxx demo_b.cxx)
target_link_libraries (helloDemo LINK_PUBLIC Hello)


