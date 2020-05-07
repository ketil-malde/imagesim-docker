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
