#!/bin/bash
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -p rc
#SBATCH -w d0038

# Setting up the environment
source env_bcftools-1.21.sh

# Creating the src directory for the installed application
mkdir -p $SOFTWARE_DIRECTORY/src

# Installing $SOFTWARE_NAME/$SOFTWARE_VERSION

# Installing bcftools 1.21
cd $SOFTWARE_DIRECTORY/src
wget https://github.com/samtools/bcftools/releases/download/1.21/bcftools-1.21.tar.bz2
tar -xjvf bcftools-1.21.tar.bz2
cd bcftools-1.21
# add in additional plugins
wget -P plugins http://raw.githubusercontent.com/freeseek/gtc2vcf/master/{idat2gtc.c,gtc2vcf.{c,h},affy2vcf.c}
./configure --prefix=$SOFTWARE_DIRECTORY
make
make install

# Creating modulefile
touch $SOFTWARE_VERSION
echo "#%Module" >> $SOFTWARE_VERSION
echo "module-whatis	 \"Loads $SOFTWARE_NAME/$SOFTWARE_VERSION module." >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "This module was built on $(date)" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "bcftools" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "The script used to build this module can be found here: $GITHUB_URL" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "To load the module, type:" >> $SOFTWARE_VERSION
echo "module load $SOFTWARE_NAME/$SOFTWARE_VERSION" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "\"" >> $SOFTWARE_VERSION
echo "" >> $SOFTWARE_VERSION
echo "conflict	 $SOFTWARE_NAME" >> $SOFTWARE_VERSION
echo "prepend-path	 PATH $SOFTWARE_DIRECTORY/bin" >> $SOFTWARE_VERSION
echo "prepend-path       LIBRARY_PATH $SOFTWARE_DIRECTORY/lib" >> $SOFTWARE_VERSION
echo "prepend-path       LD_LIBRARY_PATH $SOFTWARE_DIRECTORY/lib" >> $SOFTWARE_VERSION
echo "prepend-path       CPATH $SOFTWARE_DIRECTORY/include" >> $SOFTWARE_VERSION
echo "prepend-path       BCFTOOLS_PLUGINS $SOFTWARE_DIRECTORY/src/bcftools-1.21/plugins" >> $SOFTWARE_VERSION

# Moving modulefile
mkdir -p $CLUSTER_DIRECTORY/modulefiles/$SOFTWARE_NAME
cp $SOFTWARE_VERSION $CLUSTER_DIRECTORY/modulefiles/$SOFTWARE_NAME/$SOFTWARE_VERSION
