#!/bin/bash

# number of images to generate from each year

N=5000
CPUS=$(nproc)
JOBSIZE=$((N/CPUS))
JOBS=$((N/JOBSIZE))

OUT=sim

generate(){
    for YEAR in 2017 2018; do

	DATA=fishDatasetSimulationAlgo/fish_dataset
	CROPS=${DATA}/${YEAR}/train/crops
	BGS=${DATA}/${YEAR}/train/backgrounds
	mkdir ${OUT}-${YEAR}
	for x in $(seq 1 ${JOBS}); do
	    echo "python3 src/imagesim.py -c ${CROPS} -b ${BGS} -n ${JOBSIZE} --masks=True -o ${OUT}-${YEAR} -t ${OUT}-${YEAR}-${x}"
	done
    done | parallel -v
}

copy_val(){
    # copy 200 to validation
    mkdir -p validation/sim-2017 validation/sim-2018
    for d in sim-201?; do
	ls ${d}/${OUT}*.png | shuf | head -n 200 | while read f; do
	    mv $f validation/${d}
	    mv ${d}/$(basename $f .png).txt validation/${d}
	    mv ${d}/mask_$(basename $f .png)_* validation/${d}
	done
    done
}

list_classes(){
    # add csv files (for RetinaNet)
    cat sim-201?/*.txt > train.csv
    cat validation/sim-201?/*.txt > validation/validation.csv
    cat > classes.csv << EOF
herring,0
mackerel,1
bluewhiting,2
lanternfish,3
EOF
}

link_test(){
    # link to test data
    echo -n > test_annotations.csv
    mkdir test
    ln -s ../fishDatasetSimulationAlgo/fish_dataset/2017 test/
    ln -s ../fishDatasetSimulationAlgo/fish_dataset/2018 test/
    # This is umbersome, but some annotations don't have corresponding files
    cat fishDatasetSimulationAlgo/fish_dataset/test_annotations.csv | while read ln; do
	LINE="$(echo $ln | sed -e 's/^\//test\//g')"
	FILE="$(echo "$LINE" | cut -f1 -d,)"
	test -f "$FILE" || echo "$FILE" notfound
	test -f "$FILE" && echo "$LINE" >> test_annotations.csv
    done
}

generate
copy_val
list_classes
link_test
