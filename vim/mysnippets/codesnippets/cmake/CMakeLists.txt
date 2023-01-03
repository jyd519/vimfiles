# CMakeLists files in this project can
# refer to the root source directory of the project as ${HELLO_SOURCE_DIR} and
# to the root binary directory of the project as ${HELLO_BINARY_DIR}.
cmake_minimum_required (VERSION 2.8.11)
project (HELLO)

# Recurse into the "Hello" and "Demo" subdirectories. This does not actually
# cause another cmake executable to run. The same process will walk through
# the project's entire directory structure.
add_subdirectory (Hello)
add_subdirectory (Demo)



# Create a library called "Hello" which includes the source file "hello.cxx".
# The extension is already found. Any number of sources could be listed here.
add_library (Hello hello.cxx)

# Make sure the compiler can find include files for our Hello library
# when other libraries or executables link to Hello
target_include_directories (Hello PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})


# Add executable called "helloDemo" that is built from the source files
# "demo.cxx" and "demo_b.cxx". The extensions are automatically found.
add_executable (helloDemo demo.cxx demo_b.cxx)

# Link the executable to the Hello library. Since the Hello library has
# public include directories we will use those link directories when building
# helloDemo
target_link_libraries (helloDemo LINK_PUBLIC Hello)



# here we specify the additional include directories for the project. These files come in additional include directories option of VC++
# project.
# either the variable values from package like ${PCL_INCLUDE_DIRS} or absolute paths as shown in second and third line may be used.
include_directories(${PCL_INCLUDE_DIRS})
include_directories("G:/Matlab/extern/include")
include_directories("C:/Program Files/MobileRobots/Aria/include")


# here we specify the additional library directories for the linker in the project. These files come in additional library directories
# option of VC++ project.
# either the variable values from package like ${PCL_LIBRARY_DIRS} or absolute paths as shown in second and third line may be used.
# An update, link_directories is being pulled out, you may use TARGET_LINK_LIBRARIES instead as shown below
link_directories(${PCL_LIBRARY_DIRS})
link_directories("G:/Matlab/extern/lib/win32/microsoft")
link_directories("C:/Program Files/MobileRobots/Aria/lib")

# here we add definitions for any package if requred.
add_definitions(${PCL_DEFINITIONS})


# There may be some additional dependencies which you may have to specify for the project, which you may do as in following lines.
# Note that first parameter is the executable name.
target_link_libraries (MyApp ${PCL_LIBRARIES} libeng.lib libmx.lib libmex.lib libmat.lib Aria.lib winmm.lib wsock32.lib)
# Add the required libraries for linking:
TARGET_LINK_LIBRARIES(${sampleName}
${MRPT_LIBS} # This is filled by FIND_PACKAGE(MRPT ...)
"" # Optional extra libs...
)



