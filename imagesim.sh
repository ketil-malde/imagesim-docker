#!/bin/bash

# number of images to generate from each year

N=5000
CPUS=$(nproc)
JOBSIZE=$((N/CPUS))
JOBS=$((N/JOBSIZE))

OUT=sim

for YEAR in 2017 2018; do

  DATA=fishDatasetSimulationAlgo/fish_dataset
  CROPS=${DATA}/${YEAR}/train/crops
  BGS=${DATA}/${YEAR}/train/backgrounds
  mkdir ${OUT}-${YEAR}
  for x in $(seq 1 ${JOBS}); do
      echo "python3 src/imagesim.py -c ${CROPS} -b ${BGS} -n ${JOBSIZE} --masks=True -o ${OUT}-${YEAR} -t ${OUT}-${YEAR}-${x}"
  done
done | parallel -v

# copy 200 to validation
mkdir -p validation/sim-2017 validation/sim-2018
for d in sim-201?; do
    ls ${d}/${OUT}*.png | shuf | head -n 200 | while read f; do
	mv $f validation/${d}
	mv ${d}/$(basename $f .png).txt validation/${d}
	mv ${d}/mask_$(basename $f .png)_* validation/${d}
    done
done

# link to test data
for YEAR in 2017 2018; do
    ln -s fishDatasetSimulationAlgo/fish_dataset/$YEAR/test test-$YEAR
done
