library(stringr)
library(fs)
library(tidyverse)

# Function to convert .md header to .qmd formatted YAML header
convert_md_to_qmd <- function(input, output_file) {
  # Read the input file
  input_content <- readLines(input$inputs)
  
  # extract only the keys I care about
  filtered_content <- input_content[grep("title|date|authors|publication=|publication =|projects|url_source|url_preprint",
                                         input_content)]

  
  # Convert the header to .qmd format
  # replace key value pairs with and without surrounding []
  qmd_header <- str_replace_all(filtered_content, "(\\w+)\\s*=\\s*\"(.*)\"", "\\1: \\2")
  qmd_header <- str_replace(qmd_header, "(\\w+)\\s*=\\s*(\\[.*\\])", "\\1: \\2")
  qmd_header <- str_replace(qmd_header, "\\[(\\w+)\\]", "\\1:")
  # rename
  qmd_header <- str_replace(qmd_header, "authors:", "author:")
  qmd_header <- str_replace(qmd_header, "projects:", "categories:")
  
  # Put title and publication in quotes
  qmd_header <- str_replace(qmd_header, "(title: )(.*)", "\\1\\\"\\2\\\"")
  qmd_header <- str_replace(qmd_header, "(publication: )(.*)", "\\1\\\"\\2\\\"")

  # parse out publication into separate units
  # everything after 'publication:' and before the comma
  journ_name <- str_extract(qmd_header, '(publication: \")([^,]+)',2) |> discard(is.na)
  # the part between double **
  issue <-  str_extract(qmd_header, 'publication: \".*\\*\\*(.*?)\\*\\*',1) |> discard(is.na)
  # what's after pp.
  page <- str_extract(qmd_header, 'publication:.*(_|\\*{1})pp. (.*)(_|\\*{1})',2)  |> discard(is.na)
  # the value in the parentheses
  year <- str_extract(qmd_header, 'publication: \".*\\((\\d+)\\)',1) |> discard(is.na)
  if(length(journ_name) == 1){qmd_header <- append(qmd_header, paste0('journ: "', journ_name,'"'))}
  if(length(issue) == 1){qmd_header <- append(qmd_header, paste("issue:", issue))}
  if(length(page) == 1){qmd_header <- append(qmd_header, paste("page:", page))}
  if(length(year) == 1){qmd_header <- append(qmd_header, paste("year:", year))}
 

  # add featured image, if it exists
  if(length(dir_ls(path_dir(input$inputs),glob = "*featured*")) == 1){
    image_name <- path_file(dir_ls(path_dir(input$inputs),glob = "*featured*"))
    qmd_header <- append(qmd_header,paste("image:",image_name))
    file_copy(dir_ls(path_dir(input$inputs),glob = "*featured*"), 
              path(path_dir(output_file),image_name)
              )
  }
  
  # add pub number
  qmd_header <- append(qmd_header,paste("pub_number:",input$pub_number))
  
  qmd_header <- str_c(c("---",qmd_header,"---"), collapse = "\n")
  
  # Write the .qmd header to the output file
  writeLines(qmd_header, output_file)
  
}


inputs <- dir_ls("publications", recurse = TRUE, glob = "*.md")
pub_number <- seq(1,length(inputs), 1)
input_df <- tibble(pub_number, inputs)
input_list <- split(input_df, seq(nrow(input_df)))
# outputs <- path(path_dir(inputs), "index.qmd")
outputs <- path("publications", 
                   paste0(str_sub(inputs, start = 14L, end = 17L),
                   "_",
                   str_pad(pub_number,width = 3,side = "left",pad = 0),
                   "_",
                   str_sub(inputs, start = 25L, end = -9L)),
                   "index.qmd")

dir_create(path_dir(outputs))

# For testing
# input <- input_df[67,]
# output_file <- outputs[67]

# Convert .md to .qmd
purrr::map2(input_list, outputs, convert_md_to_qmd)

# caution 😱
# purrr::map(inputs, file_delete)
# purrr::map(path_dir(inputs), dir_delete)

dir_ls("publications", recurse = TRUE, glob = "*featured*")


