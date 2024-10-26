#! /bin/bash

# a script to create a new people entry
# creates a folder in /people with the format <lastname>-<firstname>
# prompts the user for publishing name, lastname, firstname, position, group, email, number of degrees, degree, institution, image
# strings together the number of degrees into a string of <degree> | <institution> with a separation of <br>
# writes the user input into a new index.qmd file
# saves the new index.qmd file in the corresponding people directory
# opens the new index.qmd file in Positron

# get inputs
read -p "Enter publishing name: " pub_name
read -p "Enter lastname: " lastname
read -p "Enter firstname: " firstname

# get position from predefined list (aka subtitle)
echo "Choose a position for the person:"
echo "1. Postdoctoral Fellow"
echo "2. Graduate Student, Chemistry"
echo "3. Graduate Student, Physics"
echo "4. Graduate Student, Materials Science & Engineering"
echo "5. Postbaccalaureate Researcher"
echo "6. Research Scientist"
echo "7. other"
echo "0. skip"
read -p "Enter your choice: " position_option

case $position_option in
    1) 
        position="Postdoctoral Fellow" 
        group="postdoc";;
    2) 
        position="Graduate Student, Chemistry" 
        group="gradstudent";;
    3) 
        position="Graduate Student, Physics" 
        group="gradstudent" ;;
    4) 
        position="Graduate Student, Materials Science & Engineering"
        group="gradstudent" ;;
    5) 
        position="Postbaccalaureate Researcher"
        group="postbac" ;;
    6) 
        position="Research Scientist" 
        group="researcher";;
    7) 
        read -p "Enter position: " position 
        read -p "Enter people group (i.e., gradstudent | postdoc | alumni): " group;;
    0) position="" 
        read -p "Enter people group (i.e., gradstudent | postdoc | alumni): " group;;
    *) echo "Invalid choice. Exiting..." && exit 1 ;;
esac


# # get group from predefined list (aka the grouping on the page)
# echo "Choose a group for the person:"
# echo "1. Postdoc"
# echo "2. Grad Student"
# echo "3. Post Bac"
# echo "4. Alumni"
# echo "0. skip"
# read -p "Enter your choice: " group_option

# case $group_option in
#     1) group="postdoc" ;;
#     2) group="gradstudent" ;;
#     3) group="postbac" ;;
#     4) group="alumni" ;;
#     0) group="" ;;
#     *) echo "Invalid choice. Exiting..." && exit 1 ;;
# esac

# get email from user input
read -p "Enter email: " email

# get number of degrees and degree information
read -p "Enter the number of degrees: " num_degrees


for ((i=0; i<$num_degrees; i++)); do
    read -p "Enter the degree $((i+1)): " degree
    read -p "Enter the institution $((i+1)): " institution

    degrees+=("$degree")
    institutions+=("$institution")
done

for ((i=0; i<$num_degrees; i++)); do
degrees_string+="${degrees[$i]} | ${institutions[$i]}"
    if (( i < num_degrees - 1 )); then
        # degrees_string+="\n"
        degrees_string+=" <br> "
    fi
done

# define foldername as lastname-firstname converted to lowercase
foldername=$(echo "$lastname-$firstname" | awk '{print tolower($0)}')
mkdir -p "people/${foldername}"

# create the index.qmd file
echo "---
title: &TITLE $pub_name
last: $lastname
first: $firstname
people_group: $group
email: $email
education:
  - \"$degrees_string\"
subtitle: \"$position\"
image: &IMAGE \"\"
page-layout: full
listing:
  id: pubs
  template: ../../_ejs/publications-people.ejs 
  contents: 
    - \"../../../publications/**/*.qmd\"
    - \"!../../../publications/_template/\"
  sort: \"pub_number desc\"
  filter-ui: true
  include:
    author: *TITLE
  fields: [publication, title, categories, image, date, author]
about: 
  id: about
  template: trestles
  image-shape: round
  image: *IMAGE
  links:
    - icon: envelope
      text: Email
      href: mailto:$email
---
<hr>


:::{#about}

## Education
{{< meta education >}}

:::
<br>


## {{< meta first >}}'s Group Publications

:::{#pubs}
:::



" > "people/${foldername}/index.qmd"


# open the new index.qmd file in Positron
positron "people/${foldername}/index.qmd"

echo "New people entry created at: people/${foldername}/index.qmd \nDon't Forget to add an image!"

