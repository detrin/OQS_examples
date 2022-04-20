
# MS
```
seqc 0 99 20 0 | xargs -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}
seqc 0 99 20 0 | xargs -P8 -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}
seqc 0 2499 20 0 | xargs -P4 -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}
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
seq 0 099| xargs -I{} qsub -v n={} -N j.hr_scan_3_{} mc_run.sh > submited_jobs
```