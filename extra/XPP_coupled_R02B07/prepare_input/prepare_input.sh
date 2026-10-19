#!/usr/bin/bash

set -e

# Parse command line arguments
# ============================
icon_input_dir=""
while [ "$#" -gt 0 ]; do
    case "$1" in
        --icon-input=*) icon_input_dir="${1#*=}"; shift 1;;
        *) echo "ERROR: unrecognized argument: $1" >&2; exit 1;;
    esac
done

mkdir -p "${icon_input_dir}"

if [ -z "${icon_input_dir}" ]; then
    echo "ERROR: --icon-input not specified"
    exit 1
fi

# Source settings and helper functions
# ====================================

source ./prepare_input/prepare_common.sh


# Copy necessary data for current chunk
# ======================================

# Atmosphere input
# ----------------
# aerosols - irad_aero=12 - 2 common files + annual file
rsync -av "${datadir_aerosol_kinne}/bc_aeropt_kinne_lw_b16_coa.nc" "${icon_input_dir}/."
rsync -av "${datadir_aerosol_kinne}/bc_aeropt_kinne_sw_b14_coa.nc" "${icon_input_dir}/."
rsync -av "${datadir_aerosol_kinne}/bc_aeropt_kinne_sw_b14_fin_${control_year}.nc" "${icon_input_dir}/bc_aeropt_kinne_sw_b14_fin.nc"

# ozone constant historical value
if (( control_year < 2014 )); then
    year="${control_year}"
    scenario="historical"
else
    echo "Using ozone from scenario: ssp${ssp}"
    scenario="ssp${ssp}"
    year="${control_year}"
fi
rsync -av "${datadir_ozone}/bc_ozone_${scenario}_${year}.nc"  "${icon_input_dir}/bc_ozone_${yyyy_start}.nc"
rsync -av "${datadir_ozone}/bc_ozone_${scenario}_${year}.nc"  "${icon_input_dir}/bc_ozone_$((yyyy_start - 1)).nc"

