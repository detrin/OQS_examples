
# MS
```
seqc 0 99 20 0 | xargs -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}
seqc 0 99 20 0 | xargs -P8 -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}
seqc 0 2499 20 0 | xargs -P4 -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}
ssh u-pl2 "ulimit -t unlimited; source ~/.bashrc; cd ~/Mgr/OQS_examples/master_thesis/0.1.6/hr_scan_1_v2; seqc 0 99 20 0 | xargs -I{} julia main.jl -n {}"
seq 1 ssh u-pl2 "ulimit -t unlimited; source ~/.bashrc; cd ~/Mgr/OQS_examples/master_thesis/0.1.6/hr_scan_1_v2; seqc 0 99 20 0 | xargs -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}"
seq 0 19 | xargs -P20 -I[] ssh u-pl[] "ulimit -t unlimited; source ~/.bashrc; cd ~/Mgr/OQS_examples/master_thesis/0.1.6/hr_scan_1_v2; seqc 0 99 20 [] | xargs -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}"
seq 0 19 | xargs -P20 -I[] bash -c "sleep []m; ssh u-pl[] \"ulimit -t unlimited; source ~/.bashrc; cd ~/Mgr/OQS_examples/master_thesis/0.1.6/hr_scan_1_v2; seqc 0 99 20 [] | xargs -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}\""
seq 0 4 | xargs -P20 -I[] bash -c "sleep []m; ssh u-pl[] \"ulimit -t unlimited; source ~/.bashrc; cd ~/Mgr/OQS_examples/master_thesis/0.1.6/showroom; ~/bin/julia-1.7.2/bin/julia run_[].jl\""
```

# git
```
git remote set-url origin https://<personal-token>@github.com/detrin/OQS_examples.git
```

# tmux
```
tmux -u -2 -f ~/.tmux.conf
tmux -u -2 -f /usr/share/byobu/profiles/tmuxrc new-session -n - /usr/bin/byobu-shell
```

# Meta Centrum
```
seq 0 99 | xargs -I{} qsub -v n={} -N j.hr_scan_3_{} mc_run.sh
seq 0 99 | xargs -I{} qsub -v n={} -N j.hr_scan_3_{} mc_run.sh > submited_jobs
seq 0 120 | xargs -I{} qsub -v n={} -N j.J_E_scan_1_v2_{} mc_run.sh > submited_jobs
ls data | cut -d_ -f2 | cut -d. -f1 | sort -n | awk '{for(i=p+1; i<$1; i++) print i} {p=$1}' > resubmit_job
cat resubmit_job | xargs -I{} qsub -v n={} -N j.hr_scan_5_{} mc_run.sh > submited_jobs

seq 0 9 | xargs -I{} qsub -v n={} -N j.hr_scan_1_10_005_{} mc_run.sh > submited_jobs
```

# other
```
ls -l | grep '^d' | rev | cut -d" " -f1 | rev | xargs -I{} bash -c "echo {}: ; ls {}/data | wc -l" 2>/dev/null | sed 'N;s/\n/ /'
```