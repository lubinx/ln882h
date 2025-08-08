find_package(Git REQUIRED)
set(PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# locate build script parent folder or local clone
if(NOT EXISTS "${PROJECT_DIR}/.cmake")
    if(EXISTS "${PROJECT_DIR}/../.cmake")
        get_filename_component(dir "${PROJECT_DIR}/../.cmake" ABSOLUTE)

        execute_process(
            COMMAND
                ln -s "../.cmake"
            WORKING_DIRECTORY
                ${PROJECT_DIR}
            COMMAND_ERROR_IS_FATAL ANY
        )
    else()
        execute_process(
            COMMAND
                ${GIT_EXECUTABLE} clone https://github.com/lubinx/.cmake.git --depth=1 -q
            WORKING_DIRECTORY
                ${PROJECT_DIR}
            COMMAND_ERROR_IS_FATAL ANY
        )
    endif()
endif()

set(TOOLCHAIN gcc-arm-none-eabi)
include("${PROJECT_DIR}/.cmake/build.cmake")
