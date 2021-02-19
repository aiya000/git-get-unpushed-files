#!/bin/bash

# Returns tags and branches names of the root revision of current.
function root_names () {
  local remote=$1 rev char_not_delim names

  # Parser items
  rev='\w+'
  char_not_delim='[^\)]'
  names="($char_not_delim+)" # 'names' means tags and branches names

  git log --decorate --all --oneline | grep "$remote" | head -1 | sed -E "s/$rev \(($names)\) .*/\1/"
}

# NOTE: Please use nameref feature `local -n result=$1` instead of this global variable if you can use that feature.
names_array=()

# Put given names of glob $2 into $names_array1.
function make_array_of_names() {
  local names=$1 ifs xs i

  # Convert names what are split by ',' to an array.
  ifs=$IFS
  IFS=,
  # shellcheck disable=SC2206
  xs=($names)
  IFS=$ifs

  # Trim heading and trailing spaces
  for (( i=0; i < ${#xs[@]}; i++ )) ; do
    x=${xs[$i]//^ *\| *$/}
    names_array+=("$x")
  done
}

if [[ $(git remote | wc -l) -gt 1 ]] ; then
  echo "Specifying for a remote is not implemented yet. A head remote name will be used instead." > /dev/stderr
fi
remote=$(git remote | head -1)

names=$(root_names "$remote")
make_array_of_names "$names"

for (( i=0; i < ${#names_array[@]}; i++ )) ; do
  name=${names_array[$i]}

  if echo "$name" | grep "^$remote/" > /dev/null ; then
    echo "$name"
    exit 0
  fi
done

exit 1
