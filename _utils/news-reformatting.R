library(stringr)
library(fs)
library(tidyverse)

#find files that are not already index.qmd
rename_to_index_inputs <- dir_ls("news", recurse = TRUE, glob = "*.*md") |> 
  str_remove("(^.*index.qmd)") 
# remove empty lines
rename_to_index <- rename_to_index_inputs[rename_to_index_inputs != ""]

# Make new directories and shorten the old names
new_dirnames <- rename_to_index |> str_remove(".qmd") |> 
  str_remove("news/") |> 
  str_trunc(25, side = "right") |> str_c()

new_dirs <- path("news", new_dirnames)

dir_create(new_dirs)

# Move files into new directories
file_move(rename_to_index, path("news", new_dirnames))

# rename to index
file_move(path(new_dirs, path_file(rename_to_index)), path(new_dirs, "index.qmd"))

