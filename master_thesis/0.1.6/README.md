
# hr_scan_1
Initial scan over hr factor. Short simulation.
```julia
hr1_i = parsed_args["n"] % 10 + 1
hr2_i = parsed_args["n"] ÷ 10 + 1

hr1 = 0.05 * hr1_i
hr2 = 0.05 * hr2_i
println("hr1 ", hr1)
println("hr2 ", hr2)

mols = [
        Molecule([Mode(omega=200., hr_factor=hr1)], 3, [0., 12700.]),
        Molecule([Mode(omega=200., hr_factor=hr2)], 3, [0., 12500.])
    ]

aggCore = AggregateCore(mols)
for mol_i in 2:aggCore.molCount
    aggCore.coupling[mol_i, mol_i+1] = 50
    aggCore.coupling[mol_i+1, mol_i] = 50
end
agg = setupAggregate(aggCore)
aggCore = agg.core
aggTools = agg.tools
aggOperators = agg.operators

tspan = get_tspan(0., 0.04, 500)
W0, rho0, W0_bath = ultrafast_laser_excitation(10., [0., 0.7, 0.3], agg)
elLen = aggCore.molCount+1

maxtol = 1e-6
```

# hr_scan_1_v2
Same as hr_scan_1 but with fewer simulations, just for checking. 

# hr_scan_2
Scan over smaller hr factors. Short simulation.
```julia
hr1_i = parsed_args["n"] % 10 + 1
hr2_i = parsed_args["n"] ÷ 10 + 1

hr1 = 0.01 * hr1_i
hr2 = 0.01 * hr2_i
println("hr1 ", hr1)
println("hr2 ", hr2)

mols = [
        Molecule([Mode(omega=200., hr_factor=hr1)], 3, [0., 12700.]),
        Molecule([Mode(omega=200., hr_factor=hr2)], 3, [0., 12500.])
    ]

aggCore = AggregateCore(mols)
for mol_i in 2:aggCore.molCount
    aggCore.coupling[mol_i, mol_i+1] = 50
    aggCore.coupling[mol_i+1, mol_i] = 50
end
agg = setupAggregate(aggCore)
aggCore = agg.core
aggTools = agg.tools
aggOperators = agg.operators

tspan = get_tspan(0., 0.04, 500)
W0, rho0, W0_bath = ultrafast_laser_excitation(10., [0., 0.7, 0.3], agg)
elLen = aggCore.molCount+1

maxtol = 1e-6
```

# hr_scan_3
Longer time, over 500 fs.
```julia
hr1_i = parsed_args["n"] % 10 + 1
hr2_i = parsed_args["n"] ÷ 10 + 1

hr1 = 0.05 * hr1_i
hr2 = 0.05 * hr2_i
println("hr1 ", hr1)
println("hr2 ", hr2)

mols = [
        Molecule([Mode(omega=200., hr_factor=hr1)], 3, [0., 12700.]),
        Molecule([Mode(omega=200., hr_factor=hr2)], 3, [0., 12500.])
    ]

aggCore = AggregateCore(mols)
for mol_i in 2:aggCore.molCount
    aggCore.coupling[mol_i, mol_i+1] = 50
    aggCore.coupling[mol_i+1, mol_i] = 50
end
agg = setupAggregate(aggCore)
aggCore = agg.core
aggTools = agg.tools
aggOperators = agg.operators

tspan = get_tspan(0., 0.1, 500)
W0, rho0, W0_bath = ultrafast_laser_excitation(10., [0., 0.7, 0.3], agg)
elLen = aggCore.molCount+1

maxtol = 1e-6
```

# hr_scan_3_v2
Same as hr_scan_3, except higher number of interpolation points for iter1 was used.

# hr_scan_3_v3
Same as hr_scan_3, except more strict maximal tolerance was used.

# hr_scan_4
Even longer simulation than in hr_scan_3.
```julia
hr1_i = parsed_args["n"] % 10 + 1
hr2_i = parsed_args["n"] ÷ 10 + 1

hr1 = 0.05 * hr1_i
hr2 = 0.05 * hr2_i
println("hr1 ", hr1)
println("hr2 ", hr2)

mols = [
        Molecule([Mode(omega=200., hr_factor=hr1)], 3, [0., 12700.]),
        Molecule([Mode(omega=200., hr_factor=hr2)], 3, [0., 12500.])
    ]

aggCore = AggregateCore(mols)
for mol_i in 2:aggCore.molCount
    aggCore.coupling[mol_i, mol_i+1] = 50
    aggCore.coupling[mol_i+1, mol_i] = 50
end
agg = setupAggregate(aggCore)
aggCore = agg.core
aggTools = agg.tools
aggOperators = agg.operators

tspan = get_tspan(0., 0.3, 500)
W0, rho0, W0_bath = ultrafast_laser_excitation(10., [0., 0.7, 0.3], agg)
elLen = aggCore.molCount+1

maxtol = 1e-6
```

# J_E_scan_1
Scan over J and the same \Delta E.
```julia
k = parsed_args["n"] % 11
l = parsed_args["n"] ÷ 11

DeltaE = 150. + 10. * k
J = 20. * l
println("DeltaE ", DeltaE)
println("J ", J)

mols = [
        Molecule([Mode(omega=200., hr_factor=0.5)], 3, [0., 12500.0+DeltaE]),
        Molecule([Mode(omega=200., hr_factor=0.5)], 3, [0., 12500.])
    ]

aggCore = AggregateCore(mols)
for mol_i in 2:aggCore.molCount
    aggCore.coupling[mol_i, mol_i+1] = J
    aggCore.coupling[mol_i+1, mol_i] = J
end
agg = setupAggregate(aggCore)
aggCore = agg.core
aggTools = agg.tools
aggOperators = agg.operators

tspan = get_tspan(0., 0.1, 500)
W0, rho0, W0_bath = ultrafast_laser_excitation(10., [0., 0.7, 0.3], agg)
elLen = aggCore.molCount+1

maxtol = 1e-6
```

# J_E_scan_1_v2
Similar as J_E_scan_1 but with increased number of interpolated iter1.

# J_E_scan_1_v3
Similar as J_E_scan_1 but with increased maxtol.

# omega_scan_1
Scan over omega of both LHOs. 
```julia
omega1_i = parsed_args["n"] % 11
omega2_i = parsed_args["n"] ÷ 11

omega1 = 150. + 10. * omega1_i
omega2 = 150. + 10. * omega2_i
println("hr1 ", omega1)
println("hr2 ", omega2)

mols = [
        Molecule([Mode(omega=omega1, hr_factor=0.02)], 3, [0., 12700.]),
        Molecule([Mode(omega=omega2, hr_factor=0.02)], 3, [0., 12500.])
    ]

aggCore = AggregateCore(mols)
for mol_i in 2:aggCore.molCount
    aggCore.coupling[mol_i, mol_i+1] = 50
    aggCore.coupling[mol_i+1, mol_i] = 50
end
agg = setupAggregate(aggCore)
aggCore = agg.core
aggTools = agg.tools
aggOperators = agg.operators

tspan = get_tspan(0., 0.1, 500)
W0, rho0, W0_bath = ultrafast_laser_excitation(10., [0., 0.7, 0.3], agg)
elLen = aggCore.molCount+1

maxtol = 1e-6
```

# omega_scan_2
Scan over omega of both LHOs, higher value of S_1,2 was used than in omega_scan_1.
```julia
omega1_i = parsed_args["n"] % 11
omega2_i = parsed_args["n"] ÷ 11

omega1 = 150. + 10. * omega1_i
omega2 = 150. + 10. * omega2_i
println("hr1 ", omega1)
println("hr2 ", omega2)

mols = [
        Molecule([Mode(omega=omega1, hr_factor=0.1)], 3, [0., 12700.]),
        Molecule([Mode(omega=omega2, hr_factor=0.1)], 3, [0., 12500.])
    ]

aggCore = AggregateCore(mols)
for mol_i in 2:aggCore.molCount
    aggCore.coupling[mol_i, mol_i+1] = 50
    aggCore.coupling[mol_i+1, mol_i] = 50
end
agg = setupAggregate(aggCore)
aggCore = agg.core
aggTools = agg.tools
aggOperators = agg.operators

tspan = get_tspan(0., 0.1, 500)
```

# omega_scan_3
Scan over omega of both LHOs, higher value of S_1,2 was used than in omega_scan_2.
```julia
omega1_i = parsed_args["n"] % 11
omega2_i = parsed_args["n"] ÷ 11

omega1 = 150. + 10. * omega1_i
omega2 = 150. + 10. * omega2_i
println("hr1 ", omega1)
println("hr2 ", omega2)

mols = [
        Molecule([Mode(omega=omega1, hr_factor=0.5)], 3, [0., 12700.]),
        Molecule([Mode(omega=omega2, hr_factor=0.5)], 3, [0., 12500.])
    ]

aggCore = AggregateCore(mols)
for mol_i in 2:aggCore.molCount
    aggCore.coupling[mol_i, mol_i+1] = 50
    aggCore.coupling[mol_i+1, mol_i] = 50
end
agg = setupAggregate(aggCore)
aggCore = agg.core
aggTools = agg.tools
aggOperators = agg.operators

tspan = get_tspan(0., 0.1, 500)
W0, rho0, W0_bath = ultrafast_laser_excitation(10., [0., 0.7, 0.3], agg)
elLen = aggCore.molCount+1

maxtol = 1e-6
```