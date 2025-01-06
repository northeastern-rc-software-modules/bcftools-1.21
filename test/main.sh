#!/bin/bash

mkdir -p output src

sbatch bcftools_testcase_1.sh
sbatch bcftools_testcase_2.sh

echo "All test cases have been submitted. Monitor their progress using squeue."
