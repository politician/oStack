#!/usr/bin/env bash

declare root=$PWD
declare -a folders

# Folders where terraform-docs is allowed to operate
declare valid_folders=(modules/**)

##
# Terraform format file by file
##
for file in $@; do
  terraform fmt -write $file
  folders+=($(dirname $file))
done

##
# Terraform lint folder by folder
##
declare unique_folders=($(echo ${folders[@]} | tr ' ' '\n' | sort -u | tr '\n' ' '))
declare -a tflint_results

# For each...
for folder in ${unique_folders[@]}; do

  # ...folder where terraform-docs is allowed to operate
  if [[ "${valid_folders[@]}" =~ "${folder}" ]]; then

    cd $folder

    while IFS= read -r line; do
      tflint_results+=( "${folder#"$root"}/$line" )
    done < <(tflint -f compact -c $root/.config/.tflint.hcl | grep .tf)

    cd $root

  fi

done

# If Tflint output contained messages
if [[ ! -z ${tflint_results[@]} ]]; then
  printf '%s\n' "${tflint_results[@]}"
  exit 1
fi
