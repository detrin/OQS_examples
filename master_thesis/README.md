
# MS
```
seqc 0 99 20 0 | xargs -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}
seqc 0 2499 20 0 | xargs -P4 -I{} ~/bin/julia-1.7.2/bin/julia main.jl -n {}
```

# git
```
git remote set-url origin https://<personal-token>@github.com/detrin/OQS_examples.git
```