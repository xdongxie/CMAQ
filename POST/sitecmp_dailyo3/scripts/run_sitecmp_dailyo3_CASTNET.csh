#! /bin/csh -f

# ===================== SITECMP_DAILYO3_v5.2 Run Script =============
# Usage: run.sitecmp_dailyo3_CASTNET.csh >&! sitecmp_dailyo3_V52.log &
#
# To report problems or request help with this script/program:
#             http://www.epa.gov/cmaq    (EPA CMAQ Website)
#             http://www.cmascenter.org
# ===================================================================


# ~~~~~~~~~~~~~~~~~~~~~~~~ Start EPA ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#> Portable Batch System - The following specifications are 
#> recommended for executing the runscript on the cluster at the 
#> National Computing Center used primarily by EPA.
#PBS -N run.sitecmp_dailyo3.csh
#PBS -l walltime=1:30:00
#PBS -l nodes=login
#PBS -q singlepe 
#PBS -V
#PBS -m n
#PBS -j oe
#PBS -o ./sitecmp_dailyo3.log

#> Configure the system environment
# source /etc/profile.d/modules.csh 
#> Set location of combine executable.
# setenv BINDIR /home/css/CMAQ-Tools/scripts/sitecmp_dailyo3
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~ End EPA ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ==================================================================
#> Runtime Environment Options
# ==================================================================

#> Choose compiler and set up CMAQ environment with correct 
#> libraries using config.cmaq. Options: intel | gcc | pgi
 setenv compiler intel 
 source ../../config_cmaq.csh

#> Set the model version
 set VRSN = v52

#> Set the build directory if this was not set above 
#> (this is where the executable is located by default).
 if ( ! -e ${BINDIR} ) then
  setenv BINDIR ${CMAQ_WORK}/Tools/sitecmp_dailyo3/BLD_sitecmp_dailyo3_${VRSN}_${compiler}
 endif

#> Set the name of the executable.
 setenv EXEC sitecmp_dailyo3_${VRSN}.exe


# =====================================================================
#> SITECMP_DAILYO3 Configuration Options
# =====================================================================

#> Projection sphere type used by I/OAPI (use type #20 to match WRF/CMAQ)
 setenv IOAPI_ISPH 20

#> define obs species 
 setenv OBS_SPECIES OZONE

#> define model species
 setenv OZONE "1*O3,ppb"

#> Ozone convert factor (ppm to ppb)
 setenv OBS_FACTOR "1"        # Multiply by 1000 to convert ppm to ppb

#> define time window
 setenv SDATE = "2011-07-1"    #> beginning date (July 1, 2011)
 setenv EDATE   = "2011-07-2"  #> ending date    (July 2, 2011)
 setenv START_TIME 0      
 setenv END_TIME   230000   

#> Convert SDATE and EDATE to Julian day.
#> (required format for sitecmp START_DATE and END_DATE environment variables)
 setenv START_DATE `date -ud "${SDATE}" +%Y%j`
 setenv END_DATE `date -ud "${EDATE}" +%Y%j`   

#> Number of 8hr values to use when computing daily maximum 8hr ozone.
#> Allowed values are 24 (use all 8-hr averages with starting hours 
#> from 0 - 23 hr local time) and 17 (use only the 17 8-hr averages
#> with starting hours from 7 - 23 hr local time)
 setenv HOURS_8HRMAX 24
# setenv HOURS_8HRMAX 17

#> Start and end hours for partial days. (do not use for full day calculations)
#  setenv PARTIAL_DAY "10,17" 

#> adjust for daylight savings
 setenv APPLY_DLS N

#> Number of hours to add when retrieving time steps from M3_FILE_n files during processing.
#> This should only be non-zero if the M3_FILE_n files were pre-processed with a utility like m3tshift (default 0).
 setenv TIME_SHIFT 0

#> indicate whether or not to check QA flag
 setenv QA_FLAG_CHECK Y 
 setenv QA_FLAG_HEADER "OZONE_F" 
 setenv QA_FLAG_VALUES "BCDFIMP" 

#> set missing value string
 setenv MISSING '-999'

#> Indicates whether the Lambert x/y information should be included in the output file
 setenv LAMBXY N


#############################################################
#  Input files
#############################################################

#> ioapi input files containing VNAMES (max of 10)
 setenv M3_FILE_1 [Add location of input file, e.g. COMBINE_ACONC file.]

#> SITE FILE containing site-id, longitude, latitude, time zone (tab delimited)
#> This file can be downloaded from the CMAS Center Data clearinghouse 
#> under the heading "2000-2014 North American Air Quality Observation Data":
#> https://www.cmascenter.org/download/data.cfm
#> CASTNET site file is located in AMET12_SITE_FILES.tar.gz
 setenv SITE_FILE CASTNET_sites.txt

#> input table containing site-id, time-period, and data fields
#> CASTNET obs data in the format needed for sitecmp_dailyo3 are available 
#> from the CMAS Center Data clearinghouse under the heading "2000-2014 North American Air Quality Observation Data":
#> https://www.cmascenter.org/download/data.cfm
#> Hourly CASTNET observations are located in AMET12_OBSDATA_YYYY.tar.gz for year YYYY.
 setenv IN_TABLE CASTNET_hourly_data_2011.csv

#############################################################
#  Output files
#############################################################

#> output table (comma delimited text file importable to Excel)
 setenv OUT_TABLE CASTNET_Daily_CMAQ_${VRSN}.csv

#> Executable call:
 ${BINDIR}/${EXEC}
 
 exit()