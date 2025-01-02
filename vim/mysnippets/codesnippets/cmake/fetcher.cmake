include(FetchContent)

message(STATUS "CMake ${CMAKE_VERSION}")

set(python_version 3.12.2)
set(url https://github.com/python/cpython/archive/refs/tags/v${python_version}.tar.gz)
set(git https://github.com/python/cpython.git)
set(tag v${python_version})

set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_UPDATES_DISCONNECTED ON)

function(fetcher name url tag shallow)
  string(TIMESTAMP t0 "%s")

  if(url MATCHES ".git$")
    FetchContent_Declare(${name}
    GIT_REPOSITORY "${url}"
    GIT_TAG "${tag}"
    GIT_SHALLOW "${shallow}"
    )
  else()
    FetchContent_Declare(${name} URL "${url}")
  endif()

  if(NOT ${name}_POPULATED)
    FetchContent_Populate(${name})
  endif()

  string(TIMESTAMP t1 "%s")
  math(EXPR t_url "${t1} - ${t0}")
  message(STATUS "${name}: ${t_url} seconds")

  if(NOT url MATCHES ".git$")
    cmake_path(GET url FILENAME archive_name)
    set(archive ${${name}_SOURCE_DIR}/../${name}-subbuild/${name}-populate-prefix/src/${archive_name})
    if(EXISTS ${archive})
      file(SIZE ${archive} asize)
      message(STATUS "${name}: ${archive} size [bytes] ${asize}")
    endif()
  endif()

endfunction()

# fetcher("url_archive" "${url}" "" "")
