
clear:
	rm mc_run.sh.*

submit:
	seq 0 120 | xargs -I{} qsub -v n={} -N j.omega_scan_2_{} mc_run.sh > submited_jobs
