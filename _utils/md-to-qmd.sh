#! /bin/bash
# Rename all *.md to *.qmd
for file in *.md; do 
    mv -- "$file" "${file%.md}.text"
done