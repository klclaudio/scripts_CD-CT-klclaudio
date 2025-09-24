#!/bin/bash 


# Load modules:




# Submiting variables:

# PRE-Static phase:
export STATIC_QUEUE="batch"
export STATIC_ncores=32
export STATIC_nnodes=1
export STATIC_ncpn=32
export STATIC_jobname="Pre.static"
export STATIC_walltime="02:00:00"

# PRE-Degrib phase:
export DEGRIB_QUEUE="batch"
export DEGRIB_ncores=1
export DEGRIB_nnodes=1
export DEGRIB_ncpn=1
export DEGRIB_jobname="Pre.degrib"
### export DEGRIB_walltime="00:30:00" not used yet - using STATIC_walltime

# PRE-Init Atmosphere phase:
export INITATMOS_QUEUE="batch"
export INITATMOS_ncores=64
export INITATMOS_nnodes=1
### export INITATMOS_ncpn=1 not used yet  - using INITATMOS_ncores 
export INITATMOS_jobname="Pre.InitAtmos"
### export INITATMOS_walltime="01:00:00" not used yet - using STATIC_walltime


# Model phase:
export MODEL_QUEUE="batch"
export MODEL_ncores=512
export MODEL_nnodes=8
export MODEL_ncpn=64
export MODEL_jobname="Model.MONAN"
export MODEL_walltime="8:00:00"


# Post phase:
export POST_QUEUE="batch"
### export POST_ncores=1 not used yet
export POST_nnodes=1
export POST_ncpn=32
export POST_jobname="Post.MONAN"
export POST_walltime="8:00:00"
