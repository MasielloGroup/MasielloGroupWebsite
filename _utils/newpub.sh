#! /bin/bash

# a script to create a new publication entry
# creates a folder with the format <year>_<pub_number>_<short_title>
# prompts the user for title, authors, category, url_source, url_preprint, journal, issue, page, year, image path
# the categories can chosen predefined list of "fast_electron_nano-spectroscopy", nanophotonics-quantum_optics", and "photothermal_spectroscopy_and_microscopy". Number each choice 1, 2, and 3, and allow the user to enter multiple numbers
# reformats the authors string into string with author names in quotes and separated by commas (removes the word 'and" and trims any whitespace')
# writes the user input into a new index.qmd file
# saves the new index.qmd file in the corresponding publication directory
# opens the new index.qmd file in Positron

# get current year
year=$(date +%Y)

# Extract the highest publication number, increment by 1, and pad with zeros to make it three digits
pub_number=$(printf "%03d" $(ls -d publications/* | grep -Eo '_[0-9]{3}_' | sed 's/_//g' | sort -n | tail -1 | awk '{print $1+1}'))

# get short title from user input
read -p "Enter the short title of the publication: " short_title

# create directory with the format <year>_<pub_number>_<short_title>
mkdir -p "publications/${year}_${pub_number}_${short_title}"

# prompt user for publication details
read -p "Enter the title of the publication: " title
read -p "Enter the authors of the publication (comma-separated): " authors

read -p "Enter the URL of the publication source: " url_source
read -p "Enter the URL of the preprint: " url_preprint
read -p "Enter the journal of the publication: " journal
read -p "Enter the issue of the publication (if applicable): " issue
read -p "Enter the page numbers of the publication (if applicable): " page

# format authors string into string with author names in quotes and separated by commas, the word 'and' is removed, and whitespace is trimmed
# authors_formatted=$(echo "$authors" | sed 's/ and / /g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
# authors_formatted=$(echo "$authors" | sed 's/,/","/g')
# authors_formatted=$(echo "$authors" | sed 's/\band\b//g; s/, */,","/g; s/^ *//; s/ *$//')
authors_formatted=$(echo "$authors" | sed 's/ and / /g' | sed 's/\([^,]*\)/"\1"/g' | sed 's/" *\([^"]*\) *"/"\1"/g')


# get category from predefined list
echo "Choose a category for the publication:"
echo "1. Fast electron nano-spectroscopy"
echo "2. Nanophotonics-quantum optics"
echo "3. Photothermal spectroscopy and microscopy"
echo "0. skip"
read -p "Enter your choice (1, 2, 3, or 0 to skip): " category_number

case $category_number in
    1) category="fast_electron_nano-spectroscopy" ;;
    2) category="nanophotonics-quantum_optics" ;;
    3) category="photothermal_spectroscopy_and_microscopy" ;;
    0) category="" ;;
    *) echo "Invalid choice. Exiting..." && exit 1 ;;
esac
# write user input into a new index.qmd file
echo "---
title: \"$title\"
author: [$authors_formatted]
categories: 
    - \"$category\"
url_source: \"$url_source\"
url_preprint: \"$url_preprint\"
journ: \"$journal\"
issue: $issue
page: $page
year: $year
pub_number: $pub_number
image: \"\"
---" > "publications/${year}_${pub_number}_${short_title}/index.qmd"



# open the new index.qmd file in Positron
positron "publications/${year}_${pub_number}_${short_title}/index.qmd"

echo "New publication entry created at: publications/${year}_${pub_number}_${short_title}"

