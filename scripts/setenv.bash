#!/bin/bash



# Squeduler detect:
if command -v sbatch &> /dev/null
then
   export SCHEDULER_SYSTEM="SLURM"
   echo "SLURM detected." 
elif command -v qsub &> /dev/null
then
   export SCHEDULER_SYSTEM="PBS"
   echo "PBS detected."
else
   export SCHEDULER_SYSTEM="GENERIC"
   echo "No SCHEDULER detected."
fi

# Detect hostname
THOSTNAME=$(hostname -s)

# Identifying several names of the egeon:
case ${THOSTNAME} in
   egeon-login|headnode)
      export HOSTNAME="egeon"
      export MAKE_TARG=gfortran
      export MAKE_TARG2=gfortran
      ;;
   ian[0-9]*)
      export HOSTNAME="ian"
      export MAKE_TARG=intel-xd2000
      export MAKE_TARG2=intel2-xd2000
      ;;
esac


# Make the same for other machines/systems...
echo "Host detected: $HOSTNAME"

# Set unique key: scheduler + host:
export SYSTEM_KEY="${SCHEDULER_SYSTEM}_${HOSTNAME}"


# Set environment variables and importants directories-------------------------------------------------- 

# MONAN-suite install root directories:
# Put your directories:
export DIR_SCRIPTS=$(pwd)
export DIR_DADOS=$(dirname $(dirname $(pwd)))
export MONANDIR=$MONANDIR

echo "dir dados = "${DIR_DADOS}
echo ""
echo "dir scripts = "${DIR_SCRIPTS}


# Load your system setenv:
. ${DIR_SCRIPTS}/stools/setenv_${SYSTEM_KEY}.bash

#module list
#echo ""
#read -p "mostrando modulos carregados"


#-----------------------------------------------------------------------
# We discourage changing the variables below:

# Others variables:
export OMP_NUM_THREADS=1
export OMPI_MCA_btl_openib_allow_ib=1
export OMPI_MCA_btl_openib_if_include="mlx5_0:1"
export PMIX_MCA_gds=hash
export MPI_PARAMS="-iface ib0 -bind-to core -map-by core"


# Colors:
#
export GREEN='\033[1;32m'  # Green
export RED='\033[1;31m'    # Red
export NC='\033[0m'        # No Color
export BLUE='\033[01;34m'  # Blue


# Functions: ======================================================================================================

how_many_nodes () { 
   nume=${1}   
   deno=${2}
   num=$(echo "${nume}/${deno}" | bc -l)  
   how_many_nodes_int=$(echo "${num}/1" | bc)
   dif=$(echo "scale=0; (${num}-${how_many_nodes_int})*100/1" | bc)
   rest=$(echo "scale=0; (((${num}-${how_many_nodes_int})*${deno})+0.5)/1" | bc -l)
   if [ ${dif} -eq 0 ]; then how_many_nodes_left=0; else how_many_nodes_left=1; fi
   if [ ${how_many_nodes_int} -eq 0 ]; then how_many_nodes_int=1; how_many_nodes_left=0; rest=0; fi
   how_many_nodes=$(echo "${how_many_nodes_int}+${how_many_nodes_left}" | bc )
   #echo "INT number of nodes needed: \${how_many_nodes_int}  = ${how_many_nodes_int}"
   #echo "number of nodes left:       \${how_many_nodes_left} = ${how_many_nodes_left}"
   echo "The number of nodes needed: \${how_many_nodes}  = ${how_many_nodes}"
   echo ""
}
#----------------------------------------------------------------------------------------------






