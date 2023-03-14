#! /bin/bash
# Rename all *.md to *.qmd
for file in *.md; do 
    mv -- "$file" "${file%.md}.qmd"
done