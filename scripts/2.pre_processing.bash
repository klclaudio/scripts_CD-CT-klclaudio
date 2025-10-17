#!/bin/bash 
#-----------------------------------------------------------------------------#
# !SCRIPT: pre_processing
#
# !DESCRIPTION:
#     Script to prepare boundary and initials conditions for MONAN model.
#     
#     Performs the following tasks:
# 
#        o Creates topography, land use and static variables
#        o Ungrib GFS data
#        o Interpolates to model the grid
#        o Creates initial and boundary conditions
#        o Creates scripts to run the model and post-processing (CR: to be modified to phase 3 and 4)
#        o Integrates the MONAN model ((CR: to be modified to phase 3)
#        o Post-processing (netcdf for grib2, latlon regrid, crop) (CR: to be modified to phase 4)
#
#-----------------------------------------------------------------------------#

if [ $# -ne 4 -a $# -ne 1 ]
then
   echo ""
   echo "Instructions: execute the command below"
   echo ""
   echo "${0} EXP_NAME/OP RESOLUTION LABELI FCST"
   echo ""
   echo "EXP_NAME    :: Forcing: GFS"
   echo "            :: Others options to be added later..."
   echo "RESOLUTION  :: number of points in resolution model grid, e.g: 1024002  (24 km)"
   echo "                                                                 40962  (120 km)"
   echo "LABELI      :: Initial date YYYYMMDDHH, e.g.: 2024010100"
   echo "FCST        :: Forecast hours, e.g.: 24 or 36, etc."
   echo ""
   echo "24 hour forecast example for 24km:"
   echo "${0} GFS 1024002 2024010100 24"
   echo "48 hour forecast example for 120km:"
   echo "${0} GFS   40962 2024010100 48"
   echo ""

   exit
fi

# Set environment variables exports:
echo ""
echo -e "\033[1;32m==>\033[0m Moduling environment for MONAN model...\n"
. setenv.bash


echo ""
echo "---- Pre Processing ----"
echo ""


# Standart directories variables:---------------------------------------
DIRHOMES=$(dirname "$(pwd)");          mkdir -p ${DIRHOMES}    
DIRHOMED=${DIR_DADOS}/scripts_CD-CT;   mkdir -p ${DIRHOMED}  
SCRIPTS=${DIRHOMES}/scripts;           mkdir -p ${SCRIPTS}
DATAIN=${DIRHOMED}/datain;             mkdir -p ${DATAIN}
DATAOUT=${DIRHOMED}/dataout;           mkdir -p ${DATAOUT}
SOURCES=${DIRHOMES}/sources;           mkdir -p ${SOURCES}
EXECS=${DIRHOMED}/execs;               mkdir -p ${EXECS}
#----------------------------------------------------------------------


# Input variables:--------------------------------------
EXP=${1};         #EXP=GFS
RES=${2};         #RES=1024002
YYYYMMDDHHi=${3}; #YYYYMMDDHHi=2024012000
FCST=${4};        #FCST=24
#-------------------------------------------------------


# Local variables--------------------------------------
# Calculating CIs and final forecast dates in model namelist format:
yyyymmddi=${YYYYMMDDHHi:0:8}
hhi=${YYYYMMDDHHi:8:2}
yyyymmddhhf=$(date +"%Y%m%d%H" -d "${yyyymmddi} ${hhi}:00 ${FCST} hours" )
final_date=${yyyymmddhhf:0:4}-${yyyymmddhhf:4:2}-${yyyymmddhhf:6:2}_${yyyymmddhhf:8:2}.00.00
export DIRRUN=${DIRHOMED}/run.${YYYYMMDDHHi}; rm -fr ${DIRRUN}; mkdir -p ${DIRRUN}
#-------------------------------------------------------



echo -e  "${GREEN}==>${NC} Scripts_CD-CT last commit: \n"
#git log -1 --name-only
git log | head -1

echo ""
echo ${SYSTEM_KEY}
echo ""

#echo -e  "${GREEN}==>${NC} copying and linking fixed input data ${SYSTEM_KEY}... \n"
#mkdir -p ${DATAIN}
#rsync -rv --chmod=ugo=rw ${DIRDADOS}/MONAN_datain/datain/fixed ${DATAIN}
#rsync -rv --chmod=ugo=rwx ${DIRDADOS}/MONAN_datain/execs ${DIRHOMED}
#ln -sf ${DIRDADOS}/MONAN_datain/datain/WPS_GEOG ${DATAIN}

#read -p "Verificar a copia de datain/fixed // datain/execs //  e link do WPS"

case "${SYSTEM_KEY}" in
   SLURM_egeon)
      echo -e  "${GREEN}==>${NC} copying and linking fixed input data for Egeon... \n"
      mkdir -p ${DATAIN}
      rsync -rv --chmod=ugo=rw ${DIRDADOS}/MONAN_datain/datain/fixed ${DATAIN}
      rsync -rv --chmod=ugo=rwx ${DIRDADOS}/MONAN_datain/execs ${DIRHOMED}
      ln -sf ${DIRDADOS}/MONAN_datain/datain/WPS_GEOG ${DATAIN}
      ;;
   PBS_ian)
      echo -e  "${GREEN}==>${NC} copying and linking fixed input data for IAN... \n"
      mkdir -p ${DATAIN}/fixed        
      rsync -av --exclude='x1*' ${DIRDADOS}/MONAN_datain/datain/fixed/ ${DATAIN}/fixed/
      chmod 775 ${DATAIN}/fixed/*
      #cp -f ${DIRDADOS}/MONAN_datain/execs/ungrib.exe ${EXECS}
      cp -f /p/monan/dados/MONAN_v1.4.x-CR/MONAN_datain/execs/ungrib.exe ${EXECS}
      chmod 775 ${EXECS}/*
      ln -sf ${DIRDADOS}/MONAN_datain/datain/WPS_GEOG ${DATAIN}    
      ;;

esac


#rm -fr ${DATAIN}/fixed/x1.${RES}.static.nc
#rm -fr ${DATAOUT}/logs/*
# Creating the x1.${RES}.static.nc file once, if does not exist yet:---------------
####rm -fr ${DATAIN}/fixed/x1.${RES}.static.nc
#if [ ! -s ${DATAIN}/fixed/x1.${RES}.static.nc ]
#then
#   echo -e "${GREEN}==>${NC} Creating static.bash for submiting init_atmosphere to create x1.${RES}.static.nc...\n"
   time ./make_static.bash ${EXP} ${RES} ${YYYYMMDDHHi} ${FCST}
#else
#   echo -e "${GREEN}==>${NC} File x1.${RES}.static.nc already exist in ${DATAIN}/fixed.\n"
#fi
#----------------------------------------------------------------------------------


#if [ ! -s ${DATAOUT}/${YYYYMMDDHHi}/Pre/${EXP}:${YYYYMMDDHHi:0:4}-${YYYYMMDDHHi:4:2}-${YYYYMMDDHHi:6:2}_${YYYYMMDDHHi:8:2} ]
#then
# Degrib phase:---------------------------------------------------------------------
echo -e  "${GREEN}==>${NC} Running Degrib:\n"
time ./make_degrib.bash ${EXP} ${RES} ${YYYYMMDDHHi} ${FCST}
#else
#echo -e "${GREEN}==>${NC} File ${EXP}:${YYYYMMDDHHi:0:4}-${YYYYMMDDHHi:4:2}-${YYYYMMDDHHi:6:2}_${YYYYMMDDHHi:8:2}  already exist in ${DATAOUT}/${YYYYMMDDHHi}/Pre.\n"
#fi

#----------------------------------------------------------------------------------



# Init Atmosphere phase:------------------------------------------------------------
echo -e  "${GREEN}==>${NC} Running Init Atmosphere...\n"
time ./make_initatmos.bash ${EXP} ${RES} ${YYYYMMDDHHi} ${FCST}
#----------------------------------------------------------------------------------




