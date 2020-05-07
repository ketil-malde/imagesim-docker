#!/bin/bash

# number of images to generate from each year

N=5000
for YEAR in 2017 2018; do

  DATA=fishDatasetSimulationAlgo/fish_dataset
  CROPS=${DATA}/${YEAR}/train/crops
  BGS=${DATA}/${YEAR}/train/backgrounds
  OUT=sim
  mkdir ${OUT}-${YEAR}
  python3 src/imagesim.py -c ${CROPS} -b ${BGS} -n ${N} --masks=True -o ${OUT}-${YEAR}

done

# copy 200 to validation
mkdir -p validation/sim-2017 validation/sim-2018
for d in sim-201?; do for c in {1..200}; do mv $d/${d}_${c}{.png,_mask*.png,.txt} validation/$d; done; done
