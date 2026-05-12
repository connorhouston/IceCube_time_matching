# IceCube_time_matching
WIP of working version of scripts.

## Brief explanation of scripts:
### The main time-matching process is 4 scripts: 
### pass1icecube, pass2icecube, pass2infill, and pass3combined
1. The input for the first script (`pass1icecube.py`) is the directory to the calibrated and decoded data from the SAE detector and a chosen date. The output is a CSV file that contains the data after a constant has been removed from all timestamps.
2. The input for the second script (`pass2icecube.py`) is just the chosen date. It then uses the CSV file created from the previous script to generate a filtered CSV that contains only the data from events that are coincident between at least 3 of the 8 panels that make up the SAE detector
3. The third script (`pass2infill.py`) takes the directory to the raw TA infill data and the chosen date. It then filters it to find all the events coincident between all 9 TA scintillators that surround the SAE, for a given day. It outputs a CSV file containing a list of timestamps for each of the found events. 
4. The fourth script (`pass3combined.py`) takes only the chosen date. It then uses the CSVs created by both pass2 scripts to do the main work of time matching. It outputs a CSV file for each channel/scintillator that makes up the SAE detector, each file containing the event data of only the found/time matched events. It also generates three NPZ files that contain a gaussian fit, an interpolated fit, and a linear fit of the data.

There are also the two files: `submit_timematch.condor` and `timematching.sh`, which are the submission files needed to submit a batch of timematching jobs to the cluster.

### Notes about working with the scripts:  
+ The input data for pass1icecube.py is found in the following directory within the cluster:
  `/data/exp/IceCube/2025/unbiased/surface/TA/processed/hit`  
  I would recommend taking a look through the directories within this path to get familiar with how the data is organized.
+ The input data for pass2infill.py must be downloaded from TA and unzipped before it will work with the scripts. I will get you the site and login for the TA data over secure communication. I have already downloaded and unzipped the files for all the dates in January and February of 2024, which can be found in the following directory within the cluster:
  `/home/chouston/TA_scripts/IceCube_time_matching/Infill_data`  
  If you want to work with data from any other months, they download from TA as `***.event.bz2` files, which can be unzipped using the `bunzip2` command. The scripts will need to be adjusted accordingly if you work with other months so that file paths and such stay consistent.


## Summary of current progress:
Started with the scripts from Lucas Pavlicek as well as the information on his github and google doc, both of which are linked here:
https://github.com/lucaspavlicek/IceCube_time_matching/tree/main  
https://docs.google.com/document/d/1t_3d97hWz9T-y1BrT2_LuDNIpTx8vWnzORoJfWv6n1Y/edit?usp=sharing  
I would recommend giving each of these a quick look through.  

I ran each of the four main scripts within a python environment within the cluster, to confirm they work. There was some troubleshooting that needed to be done at that point to make sure the scripts work correctly. Then, I made the condor submission files and submitted the entire month of February to the cluster. This is where we hit a large hiccup, as many of the days in February were outputting empty lists of timematched events. This needed to be investigated to determine if those days are failing to find events because the events do not exist, or if it is a problem in the code. I processed the entire month of January at that point, so we could have more dates to examine while we narrow down the problem. We found that the problem is with the pass2infill script, and is due to a given date having zero events coincident between all 9 required TA scintillators. I also worked, a bit, on what cuts could be made to further refine our event selection, and this is where the main next steps are.  

## Guidance for next steps:
I would say that there are a few quality of life changes that could be made, as well as the next steps for the research as a whole.  
### Quality of Life Suggestions:  
1. Change all four time match scripts to use argparse for the input structure, rather than the current process.
2. Change pass2infill to use num.py matching to find events coincident between all 9 scintillators, rather than go through every line individually. This should speed up the runtime of the script.
3. Edit the series of scripts so that after submitting a number of jobs to the cluster, there is a TXT file created that specifies all the days that failed and how (most likely because there are no events from pass2infill that meet the coincident requirements). I believe only pass2infill and pass3combined would need to be edited for this to happen.
### Research Suggestions:
1. Soldin suggested we make a version of pass2infill that has lighter coincident requirements (7 or 8 of the 9 TA scintillators triggered rather than all 9), this should increase the number of usable/time matched events we have which can be helpful for the later analysis.
2. We want to refine the time matching process. Make it more efficient, more effective, and with better event selection. This can be done in a number of ways, but I was looking into additional cuts we can make to refine our list of time matched events into the ones most useful for analysis.
3. It could be useful to make a script that reads every TA event for a given date, and makes a distribution of the number of times each of the 9 panels shows up in an event. This can help us determine if we are missing useful events because one of the 9 panels could have been non-datataking for a period of time. This would be done for only the days that "fail" pass2infill.
