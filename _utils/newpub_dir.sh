#! /bin/bash

# a script to create a new publication entry
# creates a folder with the format <year>_<pub_number>_<short_title>
# copies the template file `publications/_template/index.qmd` to the directory
# opens the new index.qmd file in Positron

# get current year
year=$(date +%Y)

# get next publication number
pub_number=$(ls -d publications/* | grep -Eo '_[0-9]{3}_' | sed 's/_//g' | sort -n | tail -1 | awk '{print $1+1}')

# get short title from user input
read -p "Enter the short title of the publication: " short_title

# create directory with the format <year>_<pub_number>_<short_title>
mkdir -p "publications/${year}_${pub_number}_${short_title}"

# copy the template file to the new directory
cp publications/_template/index.qmd "publications/${year}_${pub_number}_${short_title}/index.qmd"

# open the new index.qmd file in Positron
positron "publications/${year}_${pub_number}_${short_title}/index.qmd"

echo "New publication entry created at: publications/${year}_${pub_number}_${short_title}"
