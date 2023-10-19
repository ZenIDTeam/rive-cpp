cmake_minimum_required(VERSION 3.10)
include(FetchContent)

project(rive)
set(CMAKE_CXX_STANDARD 23)

# Options
set(WITH_RIVE_TEXT true)
set(WITH_RIVE_TOOLS false)


# fetch harfbuzz
FetchContent_Declare(
  harfbuzz
  GIT_REPOSITORY https://github.com/harfbuzz/harfbuzz.git
  GIT_TAG        6.0.0 
)

FetchContent_GetProperties(harfbuzz)
if(NOT harfbuzz_POPULATED)
  FetchContent_Populate(harfbuzz)
  file(GLOB_RECURSE HARFBUZZ_SOURCES "${harfbuzz_SOURCE_DIR}/src/*.cc" "${harfbuzz_SOURCE_DIR}/src/*.hh")
endif()

# fetch sheenbidi
FetchContent_Declare(
  sheenbidi
  GIT_REPOSITORY https://github.com/tehreer/sheenbidi.git
  GIT_TAG        v2.6
)

FetchContent_GetProperties(sheenbidi)
if(NOT sheenbidi_POPULATED)
  FetchContent_Populate(sheenbidi)
  file(GLOB_RECURSE SHEENBIDI_SOURCES "${sheenbidi_SOURCE_DIR}/Source/*.c" "${sheenbidi_SOURCE_DIR}/Source/*.h")
endif()



# Source files
file(GLOB_RECURSE SOURCES "src/**.cpp")


# Target
add_library(rive STATIC ${SOURCES} ${HARFBUZZ_SOURCES} ${SHEENBIDI_SOURCES})


# Include directories
target_include_directories(rive PUBLIC ${CMAKE_SOURCE_DIR}/include)
target_include_directories(rive PRIVATE ${harfbuzz_SOURCE_DIR}/src ${sheenbidi_SOURCE_DIR}/Headers)



# Compiler flags
target_compile_definitions(rive PRIVATE _USE_MATH_DEFINES)

if(MSVC)
    target_compile_options(rive PRIVATE /wd4267 /wd4244 /wd4245 /bigobj)
	add_definitions(/D_UNICODE /DUNICODE)
endif()

if(WITH_RIVE_TOOLS)
    target_compile_definitions(rive PRIVATE WITH_RIVE_TOOLS)
endif()

if(WITH_RIVE_TEXT)
    target_compile_definitions(rive PRIVATE WITH_RIVE_TEXT)
endif()



# Configurations: Debug/Release
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)
