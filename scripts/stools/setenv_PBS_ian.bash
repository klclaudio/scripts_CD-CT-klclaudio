#!/bin/bash

# Load modules:
module purge
module load PrgEnv-intel
module load intel/2025.0
module load craype-x86-turin
module load cray-hdf5/1.14.3.3
module load cray-netcdf/4.9.0.15
module load cray-parallel-netcdf/1.12.3.15
#module load grads/2.2.1
module load cdo/2.4.2
module load METIS/5.1.0
module load cray-pals
module list


# Submiting variables:

# PRE-Static phase:
export STATIC_QUEUE="pesqextra"
export STATIC_ncores=32
export STATIC_nnodes=1
export STATIC_ncpn=32
export STATIC_jobname="Pre.static"
export STATIC_walltime="02:00:00"


# PRE-Degrib phase:
export DEGRIB_QUEUE="pesqextra"
export DEGRIB_ncores=1
export DEGRIB_nnodes=1
export DEGRIB_ncpn=1
export DEGRIB_jobname="Pre.degrib"
export DEGRIB_walltime="02:00:00"


# PRE-Init Atmosphere phase:
export INITATMOS_QUEUE="pesqextra"
export INITATMOS_ncores=64
export INITATMOS_nnodes=1
export INITATMOS_ncpn=64
export INITATMOS_jobname="Pre.InitAtmos"
export INITATMOS_walltime="02:00:00"


# Model phase:
export MODEL_QUEUE="pesqextra"
export MODEL_ncores=512
export MODEL_nnodes=8
export MODEL_ncpn=64
export MODEL_jobname="Model.MONAN"
export MODEL_walltime="8:00:00"
#PBS -l select=8:ncpus=64:mpiprocs=64 ==   512mpi,  8nodes, 64cpn
#PBS -l select=16:ncpus=64:mpiprocs=64 == 1024mpi, 16nodes, 64cpn

# Post phase:
export POST_QUEUE="pesqextra"
### export POST_ncores=1 not used yet
export POST_nnodes=1
export POST_ncpn=32
export POST_jobname="Post.MONAN"
export POST_walltime="8:00:00"


# Libraries paths:
export NETCDF=${NETCDF_DIR}
export PNETCDF=${PNETCDF_DIR}
export NETCDFDIR=${NETCDF}
export PNETCDFDIR=${PNETCDF}


export DIRDADOS=/p/monan/dados/MONAN_v1.4.x
export OPERDIR=/oper/dados/ioper/tempo

#export DIRDADOS=/p/monan/dados/MONAN_v1.4.x
#export DIRDADOS=/p/scratchin/${USER}/monan/MONAN_v1.4.x
#export OPERDIR=/p/scratchin/${USER}/monan/CIs

# PIO is not necessary for version 8.* If PIO is empty, MPAS Will use SMIOL
export PIO=
export LD_LIBRARY_PATH=$NETCDF/lib:$PNETCDF/lib:$PIO/lib:$LD_LIBRARY_PATH




