
clear:
  rm mc_run.sh.*
  
submit:
  seq 0 120 | xargs -I{} qsub -v n={} -N j.omega_scan_1_{} mc_run.sh