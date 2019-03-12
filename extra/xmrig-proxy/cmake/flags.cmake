set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 11)

if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
    set(CMAKE_BUILD_TYPE Release)
endif()

if (CMAKE_BUILD_TYPE STREQUAL "Release")
    add_definitions(/DNDEBUG)
endif()

if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -fsched-stalled-insns=3 -freschedule-modulo-scheduled-loops -fsemantic-interposition -floop-parallelize-all -ftree-parallelize-loops=2 -fuse-linker-plugin -ffat-lto-objects -floop-unroll-and-jam -s -Ofast -fcx-fortran-rules")

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fsched-stalled-insns=3 -freschedule-modulo-scheduled-loops -fsemantic-interposition -floop-parallelize-all -ftree-parallelize-loops=2 -fuse-linker-plugin -ffat-lto-objects -floop-unroll-and-jam -s -Ofast -fcx-fortran-rules")

    if (XMRIG_ARMv8)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${ARM8_CXX_FLAGS}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ARM8_CXX_FLAGS} -flax-vector-conversions")
    elseif (XMRIG_ARMv7)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpu=neon")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfpu=neon -flax-vector-conversions")
    else()
        if (XMRIG_ARCH)
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=${XMRIG_ARCH} -mtune=${XMRIG_ARCH} -maes")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=${XMRIG_ARCH} -mtune=${XMRIG_ARCH} -maes")
        else()
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -maes")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -maes")
        endif()
    endif()

    if (WIN32)
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
    else()
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libgcc -static-libstdc++")
    endif()

    add_definitions(/D_GNU_SOURCE)

    if (${CMAKE_VERSION} VERSION_LESS "3.1.0")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    endif()

    #set(CMAKE_C_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -gdwarf-2")

elseif (CMAKE_CXX_COMPILER_ID MATCHES MSVC)

    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Ox /Ot /Oi /MT /GL")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Ox /Ot /Oi /MT /GL")
    add_definitions(/D_CRT_SECURE_NO_WARNINGS)
    add_definitions(/D_CRT_NONSTDC_NO_WARNINGS)
    add_definitions(/DNOMINMAX)

elseif (CMAKE_CXX_COMPILER_ID MATCHES Clang)

    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -Ofast -funroll-loops -fmerge-all-constants")

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -fno-exceptions -fno-rtti -Wno-missing-braces")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Ofast -funroll-loops -fmerge-all-constants")

    if (XMRIG_ARMv8)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${ARM8_CXX_FLAGS}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ARM8_CXX_FLAGS}")
    elseif (XMRIG_ARMv7)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfpu=neon -march=${CMAKE_SYSTEM_PROCESSOR}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfpu=neon -march=${CMAKE_SYSTEM_PROCESSOR}")
    else()
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -maes")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -maes")
    endif()

endif()
