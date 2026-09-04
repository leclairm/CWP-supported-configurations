#!/usr/bin/bash

# Variables to control the behavior of the prepare input scripts
# --------------------------------------------------------------
# Global settings
control_year="1979"
start_year="1979"
ssp="370"
revision="rcscs"
# R02B07-R02B07 settngs
atmos_grid_id="0061"             #  icon-nwp grid
atmos_refinement="R02B07"
atmos_refinement_short="r2b7"
ocean_grid_id="0062"             #  icon-oce r2b7 grid
ocean_refinement="R02B07"
initial_state_sub_path="interpolated/icon_L72_spinup_r2b7.nc"
extpar_tag="20250509"
datadir_hd_tag="r0100"
bc_land_hd_name="mc_maxl_s_v1"
ic_land_hd_name="mc_maxl_s_v1"

# Set directories
# ---------------
# Root folders
common_data_poolFolder="/capstor/store/cscs/userlab/cws01/input/icon/common"
icon_data_poolFolder="/capstor/store/cscs/userlab/cws01/input/icon/global/grids"
atmo_data_InputFolder="${icon_data_poolFolder}/atmo/${atmos_refinement}_${atmos_grid_id}"
atmos_grid_folder="${icon_data_poolFolder}/atmo/${atmos_refinement}_${atmos_grid_id}"
ocean_grid_folder="${icon_data_poolFolder}/ocean/${ocean_refinement}_${ocean_grid_id}"
# Subfolders
datadir_aerosol_kinne="${atmo_data_InputFolder}/aerosol_kinne/${revision}"
datadir_aerosol_volcanic="${common_data_poolFolder}/aerosol_volcanic_cmip6"
datadir_plumes="${common_data_poolFolder}/MACv2_simple_plumes_merged"
datadir_ozone="${atmo_data_InputFolder}/ozone/${revision}"
datadir_rad="${common_data_poolFolder}/solar_radiation"
datadir_ghg="${common_data_poolFolder}/greenhouse_gases"
datadir_hd="${icon_data_poolFolder}/atmo/${atmos_grid_id}-${ocean_grid_id}/hd/${datadir_hd_tag}"
datadir_land="${icon_data_poolFolder}/atmo/${atmos_grid_id}-${ocean_grid_id}/land/${revision}"
datadir_init="${atmo_data_InputFolder}/initial_conditions/${revision}"

# Current chunk dates
# -------------------
yyyy_start="${SIROCCO_START_DATE:0:4}"
mm_start="${SIROCCO_START_DATE:5:2}"
yyyy_stop="${SIROCCO_STOP_DATE:0:4}"
mm_stop="${SIROCCO_STOP_DATE:5:2}"

# Import and link helper function
# -------------------------------
import_and_link(){
    # WARNING: The data pool concept isn't fully safe. Better sync files for each chunk.
    #          The proper way is to add the ability to point to partial relative dates in the sirocco format.
    # TODO: Create backlob issue for Sirocco
    if [ -z "${data_pool}" ] || [ -z ${target_dir} ]; then
        echo "ERROR: data_pool and TARGET_DIR must be set before calling the function"
    fi
    local origin_path="${1}"
    local origin_name="$(basename ${origin_path})"

    local target_name="${2:-$origin_name}"
    
    local target_path="${target_dir}/${target_name}"
    local data_pool_path="${data_pool}/${target_path}"

    # - add file to data pool if not yet there
    # - link to target dir
    
    if [ ! -e "${data_pool_path}" ]; then
        if [ -e "${origin_path}" ]; then 
            rsync -av "${origin_path}/" "${data_pool_path}/"
        else
            echo "ERROR: ${origin_path} not found"
            exit 1
        fi
    fi
    
    pushd ${target_dir} >/dev/null || exit
    ln -s "${data_pool_path}" "./${target_name}"
    popd  >/dev/null || exit
}
