#!/bin/bash
#SBATCH -p short
#SBATCH --export=ALL
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH --job-name=bcftools_testcase_1
#SBATCH --output=output/bcftools_testcase_1.txt

mkdir -p output src

echo "========================================================"
echo "Test Case 1: Load BCFtools Module and Verify Version"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "Start Time: $(date)"
echo "========================================================"

module_name="bcftools/1.21"

# Load the bcftools module
echo "Loading module: $module_name"
module load $module_name
if [ $? -ne 0 ]; then
    echo "Error: Failed to load module $module_name"
    echo "End Time: $(date)"
    exit 1
fi

# Verify bcftools version
bcftools_version=$(bcftools --version | head -n 1 | awk '{print $2}')
if [[ "$bcftools_version" != "1.21" ]]; then
    echo "Error: Incorrect bcftools version. Expected 1.21, got $bcftools_version"
    echo "End Time: $(date)"
    exit 1
fi

echo "BCFtools version: $bcftools_version"
echo "Module loaded successfully."

echo "End Time: $(date)"
echo "========================================================"
