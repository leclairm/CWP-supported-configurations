#!/usr/bin/bash

basedir="${1}"
target="${2}"

rsync -av "${basedir}/" "${target}/" \
    --include="/data**" \
    --include="/externals/" --include="/externals/ecrad/" --include="/externals/ecrad/data**" \
    --include="/externals/jsbach" --include="/externals/jsbach/data" --include="/externals/jsbach/data/lctlib_nlct21.def" \
    --exclude="*"


