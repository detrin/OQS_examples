#!/bin/bash
#PBS -l select=1:ncpus=1:mem=4gb:scratch_local=10gb
#PBS -l walltime=24:00:00
#PBS -m ae

DATADIR=/storage/praha1/home/hermanda/OQS_examples/master_thesis/0.1.6/hr_scan_3

module add julia/julia-1.7.0-gcc-8.3.0-rdhfzdi
# export JULIA_PKGDIR=$HOME/.julia
export JULIA_DEPOT_PATH=/storage/brno2/home/hermanda/.julia

test -n "$SCRATCHDIR" || { echo >&2 "Variable SCRATCHDIR is not set!"; exit 1; }
echo $(pwd)
cd $SCRATCHDIR
echo $(pwd)

cp $DATADIR/main.jl main.jl
echo $(ls)
julia main.jl -n $n
cp *.h5 $DATADIR/data/

clean_scratch