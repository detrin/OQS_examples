#!/bin/bash

module add julia/julia-1.7.0-gcc-8.3.0-rdhfzdi
julia -e 'import Pkg; Pkg.add(url="https://github.com/detrin/OpenQuantumSystems.jl#master")'
julia -e 'import Pkg; Pkg.add(["HDF5", "ArgParse", "DelayDiffEq", "BenchmarkTools", "CpuId"])'
julia -e 'import Pkg; Pkg.update()'