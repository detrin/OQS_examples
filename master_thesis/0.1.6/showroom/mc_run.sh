#!/bin/bash
#PBS -l select=1:ncpus=8:mem=4gb:scratch_local=10gb:cluster=elmo5
#PBS -l walltime=48:00:00
#PBS -m ae

cat $PBS_NODEFILE
hostname
cd ${PBS_O_WORKDIR}
echo $(pwd)

# DATADIR=/storage/praha1/home/hermanda/OQS_examples/master_thesis/0.1.6/hr_scan_3

module add julia/julia-1.7.0-gcc-8.3.0-rdhfzdi
# export JULIA_PKGDIR=$HOME/.julia
# export JULIA_DEPOT_PATH=/storage/brno2/home/hermanda/.julia
echo $HOSTNAME

# test -n "$SCRATCHDIR" || { echo >&2 "Variable SCRATCHDIR is not set!"; exit 1; }
# echo $(pwd)
# cd $SCRATCHDIR
# echo $(pwd)

# cp $DATADIR/main.jl main.jl
# cp $DATADIR/update_julia.sh update_julia.sh
# chmod +x update_julia.sh
source update_julia.sh

echo $(ls)
mkdir -p data
julia run_1.jl
# cp data/*.h5 $DATADIR/data/

clean_scratch
