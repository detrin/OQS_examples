
using OpenQuantumSystems
using HDF5
using ArgParse

import DelayDiffEq

@assert OpenQuantumSystems.version == "0.1.7"

s = ArgParseSettings()
@add_arg_table s begin
    "-n"
        arg_type = Int32
end
parsed_args = parse_args(s)
println("n ", parsed_args["n"])

hr1_i = parsed_args["n"]
hr2_i = parsed_args["n"]

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

tspan = get_tspan(0., 0.1, 1000)
W0, rho0, W0_bath = ultrafast_laser_excitation(10., [0., 0.7, 0.3], agg)
elLen = aggCore.molCount+1

maxtol = 1e-6
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
_, rho_0_int_t_ = QME_sI_ansatz_const_int(
    W0,
    tspan,
    agg;
    reltol=maxtol,
    abstol=maxtol,
    int_reltol=maxtol,
    int_abstol=maxtol,
    alg = DelayDiffEq.MethodOfSteps(DelayDiffEq.Tsit5()),
)
push!(rho_int_l, rho_int_t_)
push!(sim_labels, "QME_sI_ansatz_const_int")


W_0_bath_t = []
for i=1:length(tspan)
    push!(W_0_bath_t, W0_bath.data)
end

be = :none
for ba in [:population_coherences]
    for normalize in [true]
        println("running QME_sI_iterative/1/"*string(be)*"/"*string(ba)*"/"*string(normalize))
        _, rho_1_int_t_, W_1_bath_t = QME_sI_iterative(
            W0,
            rho_0_int_t_,
            W_0_bath_t,
            tspan,
            agg;
            bath_evolution=be, 
            bath_ansatz=ba, 
            normalize=normalize,
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
        push!(rho_int_l, rho_1_int_t_)
        push!(sim_labels, "QME_sI_iterative/rho_1/"*string(be)*"/"*string(ba)*"/"*string(normalize))

        push!(rho_int_l, W_1_bath_t)
        push!(sim_labels, "QME_sI_iterative/W_bath_1/"*string(be)*"/"*string(ba)*"/"*string(normalize))

        println("running QME_sI_iterative/2/"*string(be)*"/"*string(ba)*"/"*string(normalize))
        _, rho_2_int_t_, W_2_bath_t = QME_sI_iterative(
            W0,
            rho_1_int_t_,
            W_1_bath_t,
            tspan,
            agg;
            bath_evolution=be, 
            bath_ansatz=ba, 
            normalize=normalize,
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
        push!(rho_int_l, rho_2_int_t_)
        push!(sim_labels, "QME_sI_iterative/rho_2/"*string(be)*"/"*string(ba)*"/"*string(normalize))

        push!(rho_int_l, W_2_bath_t)
        push!(sim_labels, "QME_sI_iterative/W_bath_2/"*string(be)*"/"*string(ba)*"/"*string(normalize))
    end
end
tspan_fs = tspan_cm_to_fs(tspan)

for i=1:length(rho_int_l)
    if ndims(rho_int_l[i]) == 1 
        if typeof(rho_int_l[i][1]) <: Operator
            rho_int_l[i] = operator_recast(rho_int_l[i])
        elseif typeof(rho_int_l[i][1]) <: Array
            N = length(rho_int_l[i])
            M, K = size(rho_int_l[i][1])
            temp_arr = zeros(eltype(rho_int_l[i][1]), N, M, K)
            for j=1:N
                temp_arr[j, :, :] = rho_int_l[i][j][:, :]
            end
            rho_int_l[i] = temp_arr
        end
    end
end

filename = "data/simdata_$(parsed_args["n"]).h5"
h5open(filename, "w") do file
    write(file, "n", parsed_args["n"])
    write(file, "hr1", hr1)
    write(file, "hr2", hr2)
    write(file, "tspan", tspan)
    write(file, "tspan_fs", tspan_fs)
    write(file, "OpenQuantumSystems.version", OpenQuantumSystems.version)
    for li=1:length(sim_labels)
        label = sim_labels[li]
        write(file, label, rho_int_l[li])
    end
end