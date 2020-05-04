#!/bin/bash

YEAR=2017

CROPS=/data/${YEAR}/train/crops
BGS=/data/${YEAR}/train/backgrounds

mkdir simulated_images
python3 src/imagesim.py -c ${CROPS} -b ${BGS} -n 100 -o simulated_images
