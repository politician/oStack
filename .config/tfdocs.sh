#!/usr/bin/env bash

##
# Generate Terraform docs for each changed module
##

# Folders where terraform-docs is allowed to operate
declare valid_folders=(modules/**)

# Folders that should be created if they don't exist before generating docs
declare docs_folders=(docs)

# Currently, there is no way of knowing which files terraform-docs has modified
# The files specified here will always be committed if they are in an untracked/changed state when this script is ran
# You should add files that are specified in .terraform-docs.yml or in .terraform-docs.yml situated in your valid folders
declare autocommit_files=(docs/README.md docs/inputs.md)

# Get folder path of each file
declare -a all_folders
for file in "$@"; do
  all_folders+=($(dirname $(echo $file | sed -E 's`'"$PWD"/'``g')))
done

# Remove duplicate folders
declare unique_folders=($(echo "${all_folders[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# For each...
for folder in "${unique_folders[@]}"; do

  # ...folder where terraform-docs is allowed to operate
  if [[ "${valid_folders[@]}" =~ "${folder}" ]]; then

    # Ensure the docs folders exist
    mkdir -p "${docs_folders[@]/#/$folder/}"

    # Generate docs
    terraform-docs $folder

    # Format the files accoring to the repo convention
    yarn prettier --config .prettierrc.json --write --ignore-unknown --no-error-on-unmatched-pattern "${autocommit_files[@]/#/$folder/}"

    # If there are unstaged changes in $autocommit_files
    while IFS= read -r line; do
      if [[ $line ]]; then
        git add $line
        echo "ℹ️  Added $line to your commit"
      fi
    done < <(echo $(git status --porcelain "${autocommit_files[@]/#/$folder/}" | sed -E '/^(([AM ]M)|\?\?)/!d ; s/^[AM? ]{2} ?//g'))

  fi

done
