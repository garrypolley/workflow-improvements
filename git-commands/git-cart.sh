#! /bin/bash

cd $ORG_GIT_ROOT

# This prints the header for the table. The weird format specifiers
# are to make the spacing look nice and trim if `Repo` or
# `Current Branch` are too long
printf "| %-20.20s | %-30.30s |\n" "Repo" "Current Branch"
printf "\n"
for dir in $(ls -d */) 
do
  cd $dir
  branch=$(git branch --show-current)
  printf  "| %-20.20s | %-30.30s |\n" $dir $branch
  cd ..
done
