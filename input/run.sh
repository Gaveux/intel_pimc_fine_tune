#!/bin/bash

export OMP_NUM_THREADS=1
cd /home/gaveux/intel_pimc/input

 ../pimc_intel_opt pimc.in system.in.ch4 iseed.in binning.in.ch4 interp.in.ch4 pot.402 atomperms_fr.ch4 tout/ chk/ chk_file chk/chk_file blkfile 
