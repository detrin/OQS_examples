#!/bin/bash

julia -e 'import Pkg; Pkg.add(url="https://github.com/detrin/OpenQuantumSystems.jl#master")'
julia -e 'import Pkg; Pkg.add(["HDF5", "ArgParse", "DelayDiffEq", "BenchmarkTools", "CpuId"])'
julia -e 'import Pkg; Pkg.update()'