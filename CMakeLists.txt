
# CMake project file for PIMC

cmake_minimum_required (VERSION 2.6)
project (pimc)
enable_language (Fortran)

#make sure that the default is a RELEASE
if (NOT CMAKE_BUILD_TYPE)
	set (CMAKE_BUILD_TYPE RELEASE CACHE STRING 
        "Choose the type of build, Options are: None Debug Release."
        FORCE)
endif (NOT CMAKE_BUILD_TYPE)

#Define the command line options
set (POT "msi" CACHE STRING "The potential energy surface to be used")
option(FREE "Specify whether free energy calculations should be possible" OFF)

string(TOLOWER "${POT}" potential)


#if the free energy calculation parameter is passed define the free energy
#argument for the code
if(FREE)
	message(STATUS "Building with Free Energy Calculations on")
	add_definitions(-DFREE_ENERGY)
endif()

#if the potential string is specified and has one of the values below
#set the POT argument for the preprocessor
if("${potential}" STREQUAL "msi")
	add_definitions(-DPOT=0)
	message(STATUS "Generating msi build script")
elseif("${potential}" STREQUAL "h2o")
	add_definitions(-DPOT=1)
	message(STATUS "Generating H2O build script")
elseif("${potential}" STREQUAL "nh3")
	add_definitions(-DPOT=2)
	message(STATUS "Generating NH3 build script")
elseif("${potential}" STREQUAL "hcn")
	add_definitions(-DPOT=3)
	message(STATUS "Generating HCN build script")
else ()
	add_definitions(-DPOT=0)
	message(STATUS "Unable to identify potential. Generating msi build script")
endif ()

#default installation
get_filename_component (default_prefix ".." ABSOLUTE)
set (CMAKE_INSTALL_PREFIX ${default_prefix} CACHE STRING
    "Choose the installation directory; by default it installs in the PIMC directory."
    FORCE)

#FFLAGS depend on the compiler
get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

if (Fortran_COMPILER_NAME MATCHES "gfortran.*")
    #gfortran
    message ("Fortran compiler: " ${Fortran_COMPILER_NAME})
    set (CMAKE_Fortran_FLAGS_RELEASE "-O3 -ffree-form -cpp -ffixed-line-length-none -fno-range-check")
    set (CMAKE_Fortran_FLAGS_DEBUG "-O0 -g -Wall -fopenmp -fno-range-check -pedantic -ffree-form -ffixed-line-length-none  -cpp -g -fbacktrace -fcheck=all")
elseif (Fortran_COMPILER_NAME MATCHES "ifort.*")
    #ifort
    message ("Fortran compiler: " ${Fortran_COMPILER_NAME})
    set (CMAKE_Fortran_FLAGS_RELEASE "-fast -align all -extend-source -r8 -qmkl")
    #-I${ADVISOR_2021_DIR}/include/intel64 -L${ADVISOR_2021_DIR}/lib64 -ladvisor")
    #-I /home/gaveux/Projekt/Library/include -L/home/gaveux/Projekt/Library/lib -lnetcdf")
    set (CMAKE_Fortran_FLAGS_DEBUG "-g -traceback -debug all -check all -align all -extend-source -r8 -qmkl -I /home/gaveux/Projekt/Library/include")
# -align all -extend_source -traceback -check all -warn all  -check arg_temp_created -debug all -r8 ") 
else ()
    message ("CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
    message ("Fortran compiler: " ${Fortran_COMPILER_NAME})
    message ("No optimised Fortran compiler flags are known, we just try -O2...")
    set (CMAKE_Fortran_FLAGS_RELEASE "-O2")
    set (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g")
endif ()

#add the source files
add_executable(pimc_intel_opt src/action.F90 src/binning_mod.F90 src/estimator_class.F90 src/FreeEnergy.F90 src/molspec_mod.F90 src/mod_seed.F90 src/move_beads.F90 src/mt19937ar.F90 src/prng.F90 src/pimc_main.F90 src/pimc_mod.F90 src/pimc_monte.F90 src/pimc_setup.F90 src/read_iseed.F90 src/read_pimc.F90 src/read_system.F90 src/vars_class.F90 src/Potentials/jp4016728_si_001.F90 src/Potentials/PJT2.F90 src/Potentials/Potential_HCN.F90 src/Potentials/MSI/bondperms.F90 src/Potentials/MSI/calcen.F90 src/Potentials/MSI/intern.F90 src/Potentials/MSI/interp_mod.F90 src/Potentials/MSI/neigh.F90 src/Potentials/MSI/read_interp.F90 src/Potentials/MSI/read_pot.F90 src/Potentials/MSI/msi_mod.F90 src/block_count.F90 src/blocking.F90) #src/netcdf_utility.F90) #src/Potentials/MSI/cal_d2Vdx2.F90)


install (TARGETS pimc_intel_opt DESTINATION "bin")

