cmake_minimum_required(VERSION 3.20)

if(TARGET ${executable})
    project("ultracore LN882H driver")

#############################################################################
# 💡 device part number selection
#
#       LN882H ${PIN} ${FLASH}
#           PIN
#               F       24 pins
#               K       32 pins
#           FLASH
#               E       512K
#               G       1024K
#               I       2024K
#############################################################################
    if(${DEVICE_PART} MATCHES "LN882H*")
        string(SUBSTRING ${DEVICE_PART} 6 1 PIN)
        string(SUBSTRING ${DEVICE_PART} 7 1 FLASH)
    else()
        message("❌ invalid ${DEVICE_PART}")
        message(FATAL_ERROR)
    endif()

    build_driver("armv7e-m" "fpv4-sp-d16"
        INCLUDE_DIRS
            "include"
            "ln882h_device"
            "ln882h_device/reg"
            "demo"
        # PRIVATE_INCLUDE_DIRS
        #     "sdk/LN882H_algo_lib/inc"
        SRCS
            "*.c"
            "ln882h_device/hal/*.c"
        CONFIG_FILES
            "config/LN882H_config.h"
        LINKER_SCRIPTS
            # "gcc/LN882H.ld"
            "gcc/LN882H${PIN}${FLASH}.ld"
        # SVD
        #     "svd/LN882H.svd"
        DEFINITIONS
            "LN882H"
        COMPILE_OPTIONS
            "-Wno-conversion"
            "-Wno-sign-conversion"
            "-Wno-enum-compare"
            "-Wno-type-limits"
            "-Wno-undef"
    )

#############################################################################
# 💡 build demo project
#############################################################################
else()
    include(".vscode/intro.cmake")
    project("ultracore LN882H demo")

    # remove prebuild ultracore archs
    file(GLOB glob_list "${CMAKE_BINARY_DIR}/demo.*")
    foreach(iter ${glob_list})
        file(REMOVE ${iter})
    endforeach()

    build_target(demo
        DEVICE
            "LN882HKI"
        INCLUDE_DIRS
            "./demo"
        DRIVER
            "."
        CONFIG_DIR
            "demo/config"
        SRCS
            "demo/main.C"
        DEFINITIONS
            NO_BLUETOOTH
            NVM_TAG="ln882h_nvm"
    )
    print_targets()
endif()
