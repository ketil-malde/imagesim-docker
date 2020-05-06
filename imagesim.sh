#!/bin/bash

YEAR=2017

DATA=fishDatasetSimulationAlgo/fish_dataset
CROPS=${DATA}/${YEAR}/train/crops
BGS=${DATA}/${YEAR}/train/backgrounds

mkdir simulated_images
python3 src/imagesim.py -c ${CROPS} -b ${BGS} -n 10 --masks=True -o simulated_images
