
using OpenQuantumSystems
using HDF5
using ArgParse

import DelayDiffEq

@assert OpenQuantumSystems.version == "0.1.6"

mols = [
        Molecule([Mode(omega=200., hr_factor=0.1)], 3, [0., 12700.]),
        Molecule([Mode(omega=200., hr_factor=0.1)], 3, [0., 12500.])
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

tspan = get_tspan(0., 1., 5000)
W0, rho0, W0_bath = ultrafast_laser_excitation(10., [0., 0.7, 0.3], agg)
elLen = aggCore.molCount+1

maxtol = 1e-8
rho_int_l = []
sim_labels = []

println("running Evolution_sI_exact")
_, rho_int_t_ = Evolution_sI_exact(W0, tspan, agg)
push!(rho_int_l, rho_int_t_)
push!(sim_labels, "Evolution_sI_exact")

println("running QME_sI_ansatz_test")
_, rho_int_t_ = QME_sI_ansatz_test(
    W0,
    tspan,
    agg;
    reltol = maxtol,
    abstol = maxtol,
    int_reltol = maxtol,
    int_abstol = maxtol,
    alg = DelayDiffEq.MethodOfSteps(DelayDiffEq.Tsit5()),
)
push!(rho_int_l, rho_int_t_)
push!(sim_labels, "QME_sI_ansatz_test")

println("running QME_sI_ansatz_const_int")
_, rho_int_t_ = QME_sI_ansatz_const_int(
    W0,
    tspan,
    agg;
    reltol = maxtol,
    abstol = maxtol,
    int_reltol = maxtol,
    int_abstol = maxtol,
    alg = DelayDiffEq.MethodOfSteps(DelayDiffEq.Tsit5()),
)
push!(rho_int_l, rho_int_t_)
push!(sim_labels, "QME_sI_ansatz_const_int")

### QME_sI_ansatz_upart1

println("running QME_sI_ansatz_upart1_int")
_, rho_int_t_ = QME_sI_ansatz_upart1_int(
    W0,
    tspan,
    agg;
    reltol = maxtol,
    abstol = maxtol,
    int_reltol = maxtol,
    int_abstol = maxtol,
    alg = DelayDiffEq.MethodOfSteps(DelayDiffEq.Tsit5()),
)
push!(rho_int_l, rho_int_t_)
push!(sim_labels, "QME_sI_ansatz_upart1_int")

### QME_sI_ansatz_upart2

println("running QME_sI_ansatz_upart2_int")
_, rho_int_t_ = QME_sI_ansatz_upart2_int(
    W0,
    tspan,
    agg;
    reltol = maxtol,
    abstol = maxtol,
    int_reltol = maxtol,
    int_abstol = maxtol,
    alg = DelayDiffEq.MethodOfSteps(DelayDiffEq.Tsit5()),
)
push!(rho_int_l, rho_int_t_)
push!(sim_labels, "QME_sI_ansatz_upart2_int")

println("running QME_sI_iterative_1")
_, rho_int_t_ = QME_sI_iterative_1(
    W0,
    tspan,
    agg;
    w_1_interpolate_count = 500,
    reltol = maxtol,
    abstol = maxtol,
    int_reltol = maxtol,
    int_abstol = maxtol,
    W_1_rtol = maxtol,
    W_1_atol = maxtol,
    K_rtol = maxtol,
    K_atol = maxtol,
    alg = DelayDiffEq.MethodOfSteps(DelayDiffEq.Tsit5()),
)
push!(rho_int_l, rho_int_t_)
push!(sim_labels, "QME_sI_iterative_1")

tspan_fs = tspan_cm_to_fs(tspan)

for i=1:length(rho_int_l)
    rho_int_l[i] = operator_recast(rho_int_l[i])
end

filename = "data/simdata_1.h5"
h5open(filename, "w") do file
    write(file, "tspan", tspan)
    write(file, "tspan_fs", tspan_fs)
    write(file, "OpenQuantumSystems.version", OpenQuantumSystems.version)
    for li=1:length(sim_labels)
        label = sim_labels[li]
        write(file, label, rho_int_l[li])
    end
end