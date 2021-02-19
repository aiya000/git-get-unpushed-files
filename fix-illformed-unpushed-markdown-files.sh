#!/bin/bash

unpushed_files=$(base -c "$(dirname "$0")/get-unpushed-files.sh")

unpushed_markdowns=()
for (( i=0; i < ${#unpushed_files[@]}; i++ )) ; do
  file=${unpushed_files[$i]}

  if echo "$file" | grep '\.md$' > /dev/null ; then
    unpushed_markdowns+=("$file")
  fi
done

function is-there-illformed-markdowns () {
  markdown_files=$1
  root_dir=$(git rev-parse --show-toplevel)

  # shellcheck disable=SC2086
  [[ "$markdown_files" != '' ]] && \
    ! textlint --config "$root_dir/.textlintrc" $markdown_files > /dev/null
}

echo 'Checking for textlint...'
unpushed=$(get-unpushed-markdowns)
if [[ $unpushed = '' ]] ; then
  exit 0
fi

echo "Checking for $unpushed"
if is-there-illformed-markdowns "$unpushed" ; then
  echo 'textlint format error detected.'
  exit 1
fi
