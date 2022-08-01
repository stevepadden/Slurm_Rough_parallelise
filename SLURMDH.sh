#!/bin/bash -l
	ulimit -s unlimited   #Unlocking the maximum stack size – you may or may not need this
	corenum=$SLURM_ARRAY_TASK_MAX #Extracting the core number from first input argument
	Iteration="$((SLURM_ARRAY_TASK_ID))"
	mkdir "core_$Iteration" 2>/dev/null #Make new Dir
	cp *.in "core_$Iteration" 2>/dev/null #Copy input files - Within MDRange, all input files are denoted as ".in" files 
	cp runMDH "core_$Iteration" 2>/dev/null #Copy run file - For MDRange, the run file is called runMDH, other simulation codes will differ
  
  #Following steps adjust the logic required within MDRange source files, an initial number of particles aswell as the seed is changed accordingly.
  #Other programs will need the REGEX changed here to reflect what needs changing in their simulation setups.
  #An initial simulation file of N particles is split into N/corenum individual simulations each with a different seed, 
  
	initial_N=$(grep -oP '(?<=reccalc->Ncalc:= )[0-9]+' param.in) #Finding the intial number of particles
	initial_seed=$(grep -oP '(?<=gen->seed:= )[0-9]+' param.in) #Finding the intial seed
	new_N=$(( initial_N / corenum ))  #Finding new number of particles per run
	cd "core_$Iteration"  #Moving to this runs directory

	#Note on the next line " is needed to preserve the spaces - single comments ' dont in sed
	sed -i "s/reccalc->Ncalc:= ${initial_N}/reccalc->Ncalc:= ${new_N}/g" "param.in"   #Search and edit for Ncalc (number of particles) within this directories param in 
	current_seed=$((initial_seed + $Iteration)) #Adding one to the seed, necessary to ensure each simulation is different
	sed -i "s/gen->seed:= ${initial_seed}/gen->seed:= ${current_seed}/g" "param.in"
	./runMDH   #Running in this current directorys run file (. not /)
	cd ..    #Returning back to home directory (may not be needed)
