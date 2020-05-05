#!/bin/bash

YEAR=2017

CROPS=/data/${YEAR}/train/crops
BGS=/data/${YEAR}/train/backgrounds

mkdir simulated_images
python3 src/imagesim.py -c ${CROPS} -b ${BGS} -n 10 --masks=True -o simulated_images
