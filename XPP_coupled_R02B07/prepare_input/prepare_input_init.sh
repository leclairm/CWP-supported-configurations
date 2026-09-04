#!/usr/bin/bash

set -e

script_dir=$(cd "$(dirname "$0")"; pwd)

# Parse command line arguments
# ============================
icon_squash=""
basedir=""
while [ "$#" -gt 0 ]; do
    case "$1" in
        --icon-squash=*) icon_squash="${1#*=}"; shift 1;;
        --basedir=*) basedir="${1#*=}"; shift 1;;
        *) echo "ERROR: unrecognized argument: $1" >&2; exit 1;;
    esac
done

if [ -n "${icon_squash}" ] && [ -n "${basedir}" ]; then
    echo "ERROR: cannot specify both --icon-squash and --basedir"
    exit 1
fi
if [ -z "${icon_squash}" ] && [ -z "${basedir}" ]; then
    echo "ERROR: specify either --icon-squash or --basedir"
    exit 1
fi


# Source settings and helper functions
# ====================================
source ${script_dir}/prepare_common.sh

# Copy constant input data over the simulation
# ============================================
target_basedir="icon_basedir"
if [ -n "${icon_squash}" ]; then
    icon_mount=$(realpath "./ICON_MOUNT")
    mkdir -p "${icon_mount}"
    uenv run ${icon_squash}:${icon_mount} -- ${script_dir}/get_input_from_basedir.sh "${icon_mount}" "${target_basedir}"
else
    ${script_dir}/get_input_from_basedir.sh "${basedir}" "${target_basedir}"
fi

# Atmosphere input
# ----------------
rsync -av "${atmos_grid_folder}/icon_grid_${atmos_grid_id}_${atmos_refinement}_G.nc" "atmo_grid.nc"
rsync -av "${datadir_land}/icon_extpar4jsbach_${atmos_grid_id}_${extpar_tag}_tiles_jsb.nc" "extpar_file.nc"
rsync -av "${datadir_init}/ifs2icon_${start_year}010100_${atmos_grid_id}_${atmos_refinement}_G.nc" "ifs2icon.nc"
rsync -av "${datadir_rad}/swflux_14band_cmip6_${control_year}ADconst_999-2301-v3.2.nc" "bc_solar_irradiance.nc"

# Ocean innput
# ------------
rsync -av "${ocean_grid_folder}/icon_grid_${ocean_grid_id}_${ocean_refinement}_O.nc" "ocean_grid.nc"
rsync -av "${ocean_grid_folder}/ocean/initial_conditions/${initial_state_sub_path}" "ocean_init_state.nc"

# Land input
# ----------
rsync -av "${datadir_land}/bc_land_frac_11pfts_${control_year}.nc" "land_frac.nc"
rsync -av "${datadir_hd}/hdpara_${atmos_refinement_short}_${atmos_grid_id}_${ocean_grid_id}_${bc_land_hd_name}.nc" "bc_land_hd.nc"
rsync -av "${datadir_hd}/hdstart_${atmos_refinement_short}_${atmos_grid_id}_${ocean_grid_id}_${ic_land_hd_name}.nc" "ic_land_hd.nc"
rsync -av "${datadir_land}/bc_land_phys.nc" "."
rsync -av "${datadir_land}/bc_land_soil.nc" "."
rsync -av "${datadir_land}/ic_land_soil.nc" "."
rsync -av "${datadir_land}/bc_land_sso.nc" "."
