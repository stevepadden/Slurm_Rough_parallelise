# Slurm_Rough_parallelise
Two files which handle the rough parellelisation of MDRange. This routine is adaptable to many other codes.

SLURMDH.sh handles all the logic required for adjusting input files, each input file is adjusted using REGEX and SED in combination. 
Initially set up the simulation in the main folder, set up all input scripts etc here. After this setup, call:

$bash Shell.sh 50

Which then sets up 50 individual folders, each with a division of the overall number of particles and a unique seed. As such the program is now sufficiently parallelised.

It is suggested to write a custom script to combine all outputs into a single file to enable easy analysis.
