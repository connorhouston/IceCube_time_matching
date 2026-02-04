#!/bin/bash

icecubedirectory='/data/exp/IceCube/2025/unbiased/surface/TA/processed/hit'
infilldirectory='/home/chouston/TA_scripts/IceCube_time_matching/Infill_data'
DAY="$1"
source /home/chouston/python_envs/TA_python/bin/activate

echo Starting IceCube pass 1 at local machine time:
date
python pass1icecube.py $icecubedirectory $DAY

echo Finished IceCube pass 1
echo Starting IceCube pass 2 at local machine time:
date
python pass2icecube.py $DAY

echo Finished IceCube pass 2
echo Starting Infill pass 2 at local machine time:
date
python pass2infill.py $infilldirectory $DAY

echo Finished Infill pass 2
echo Starting combined pass 3 at local machine time:
date
python pass3combined.py $DAY

echo Finished time matching for $DAY at local machine time:
date
