#!/bin/bash
#SBATCH -p short
#SBATCH --export=ALL
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH --job-name=bcftools_testcase_2
#SBATCH --output=output/bcftools_testcase_2.txt

mkdir -p output src

echo "========================================================"
echo "Test Case 2: Filter Variants Using BCFtools"
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $(hostname)"
echo "Start Time: $(date)"
echo "========================================================"

module load bcftools/1.21

# Create a sample VCF file (if not already provided)
sample_vcf="src/sample.vcf"
filtered_vcf="output/sample_filtered.vcf"

if [ ! -f "$sample_vcf" ]; then
    echo "Creating a sample VCF file..."
    cat <<EOF > $sample_vcf
##fileformat=VCFv4.2
##contig=<ID=chr1,length=1000>
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	sample1
chr1	100	.	A	G	50	PASS	.	GT	0/1
chr1	200	.	T	C	20	PASS	.	GT	0/0
EOF
fi

# Filter variants with QUAL >= 30 using bcftools view command
echo "Filtering variants with QUAL >= 30..."
bcftools view -i 'QUAL>=30' "$sample_vcf" -o "$filtered_vcf" -Ov

if [ $? -ne 0 ]; then
    echo "Error: Failed to filter variants."
    echo "End Time: $(date)"
    exit 1
fi

# Verify the filtered VCF file contains only high-quality variants (QUAL >= 30)
filtered_count=$(grep -vc '^#' "$filtered_vcf")
if [ "$filtered_count" -ne 1 ]; then
    echo "Error: Unexpected number of filtered variants in the output VCF."
    echo "End Time: $(date)"
    exit 1
fi

echo "Variants filtered successfully. Output written to $filtered_vcf."
echo "End Time: $(date)"
echo "========================================================"
