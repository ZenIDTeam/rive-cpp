cmake_minimum_required(VERSION 3.10)
include(FetchContent)

project(riveRenderer)

set(CMAKE_CXX_STANDARD 23)
set(SOURCE_DIR src)
set(INCLUDE_DIR include)
set(CMAKE_BUILD_TYPE Release)

# fetch libtess2
FetchContent_Declare(
  libtess2
  GIT_REPOSITORY https://github.com/memononen/libtess2.git
  GIT_TAG        master  # Optionally specify a version tag or branch here
)

FetchContent_GetProperties(libtess2)
if(NOT libtess2_POPULATED)
  FetchContent_Populate(libtess2)
  file(GLOB LIBTESS2_SOURCES "${libtess2_SOURCE_DIR}/Source/*.c" "${libtess2_SOURCE_DIR}/Source/*.h")
endif()

# fetch earcut
FetchContent_Declare(
  earcut
  GIT_REPOSITORY https://github.com/mapbox/earcut.hpp.git
  GIT_TAG        master  # Optionally specify a version tag or branch here
)

FetchContent_GetProperties(earcut)
if(NOT earcut_POPULATED)
  FetchContent_Populate(earcut)
endif()


# fetch sokol directly to include
set(SOKOL_REPO "https://raw.githubusercontent.com/luigi-rosso/sokol")
set(SOKOL_STABLE_BRANCH "support_transparent_framebuffer")
set(SOKOL_HEADER_URL "${SOKOL_REPO}/${SOKOL_STABLE_BRANCH}/sokol_gfx.h")
file(DOWNLOAD ${SOKOL_HEADER_URL} ${CMAKE_SOURCE_DIR}/Include/sokol_gfx.h SHOW_PROGRESS)

#set(EARCUT_HEADER_URL "https://raw.githubusercontent.com/mapbox/earcut.hpp/master/include/mapbox/earcut.hpp")
#file(DOWNLOAD ${EARCUT_HEADER_URL} ${CMAKE_SOURCE_DIR}/extern/earcut.hpp SHOW_PROGRESS)

file(GLOB_RECURSE SOURCES "${SOURCE_DIR}/*.cpp")
add_library(riveRenderer STATIC ${SOURCES} ${SOURCE_DIR}/sokol/generated/shader.h ${LIBTESS2_SOURCES})
target_include_directories(riveRenderer PRIVATE ${libtess2_SOURCE_DIR}/Include)
target_include_directories(riveRenderer PRIVATE ${earcut_SOURCE_DIR}/include/mapbox)
target_include_directories(riveRenderer PRIVATE ${CMAKE_SOURCE_DIR}/../include)
target_include_directories(riveRenderer PUBLIC ${INCLUDE_DIR})

