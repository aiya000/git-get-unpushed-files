#!/bin/bash

current_dir=$(dirname "$0")
remote_latest_branch=$(bash -c "$current_dir/get-root-branch.sh")
current_branch=$(git branch --show-current)

git diff --stat "$remote_latest_branch..$current_branch" --name-only
