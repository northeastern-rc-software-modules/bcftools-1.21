#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -p rc  #change to appropriate partition
#SBATCH -w d0038
#SBATCH -t 00:10:00

# load the module

module load bcftools/1.21

# test the module

bcftools plugin -lv

