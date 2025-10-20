#!/bin/bash

# Load modules:
module purge
module load PrgEnv-intel
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
export STATIC_ncores=128
export STATIC_nnodes=1
export STATIC_ncpus=128
export STATIC_ncpn=128
export STATIC_nthreads=1
export STATIC_jobname="Pre.static"
export STATIC_walltime="02:00:00"


# PRE-Degrib phase:
export DEGRIB_QUEUE="pesqextra"
export DEGRIB_ncores=1
export DEGRIB_nnodes=1
export DEGRIB_ncpus=1
export DEGRIB_ncpn=1
export DEGRIB_nthreads=1
export DEGRIB_jobname="Pre.degrib"
export DEGRIB_walltime="02:00:00"


# PRE-Init Atmosphere phase:
export INITATMOS_QUEUE="pesqextra"
export INITATMOS_ncores=128
export INITATMOS_nnodes=1
export INITATMOS_ncpus=128
export INITATMOS_ncpn=128
export INITATMOS_nthreads=1
export INITATMOS_jobname="Pre.InitAtmos"
export INITATMOS_walltime="02:00:00"


# Model phase:
export MODEL_QUEUE="pesqextra"
export MODEL_ncores=8192
export MODEL_nnodes=32
export MODEL_ncpus=256
export MODEL_ncpn=256
export MODEL_nthreads=1
export MODEL_jobname="Model.MONAN"
export MODEL_walltime="8:00:00"
#PBS -l select=8:ncpus=64:mpiprocs=64 ==   512mpi,  8nodes, 64cpn
#PBS -l select=16:ncpus=64:mpiprocs=64 == 1024mpi, 16nodes, 64cpn

# Post phase:
export POST_QUEUE="pesqextra"
export POST_ncores=32
export POST_nnodes=1
export POST_ncpus=32
export POST_ncpn=32
export POST_nthreads=1
export POST_jobname="Post.MONAN"
export POST_walltime="8:00:00"


# Libraries paths:
export NETCDF=${NETCDF_DIR}
export PNETCDF=${PNETCDF_DIR}
export NETCDFDIR=${NETCDF}
export PNETCDFDIR=${PNETCDF}


export DIRDADOS=/p/monan/dados/MONAN_v1.4.x
export OPERDIR=/oper/dados/ioper/tempo


# PIO is not necessary for version 8.* If PIO is empty, MPAS Will use SMIOL
export PIO=
export LD_LIBRARY_PATH=$NETCDF/lib:$PNETCDF/lib:$PIO/lib:$LD_LIBRARY_PATH


#
# -------- Tested Configurations ---------
#

#export MODEL_ncores=8192
#export MODEL_nnodes=32
#export MODEL_ncpus=256
#export MODEL_ncpn=256
#export MODEL_nthreads=1

#export MODEL_ncores=7680
#export MODEL_nnodes=30
#export MODEL_ncpus=256
#export MODEL_ncpn=256
#export MODEL_nthreads=1

#export MODEL_ncores=1024
#export MODEL_nnodes=16
#export MODEL_ncpus=256
#export MODEL_ncpn=64
#export MODEL_nthreads=4

#export MODEL_ncores=4096
#export MODEL_nnodes=20
#export MODEL_ncpus=256
#export MODEL_ncpn=256
#export MODEL_nthreads=1

#export MODEL_ncores=6144
#export MODEL_nnodes=24
#export MODEL_ncpus=256
#export MODEL_ncpn=256
#export MODEL_nthreads=1
