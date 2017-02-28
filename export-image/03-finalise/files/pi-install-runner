#!/bin/bash
if [ $# != 3 ]; then
    echo "Usage: `basename $0` <git-repo> <path/to/workdir> <path/to/logdir>"
    exit 0
fi
repo=$1
target=$2
log_dir=$3

date_str=$(date +%Y-%m-%d:%H:%M:%S)
log_file="$log_dir/run_$date_str.log"
echo "--- run install $date_str ---"
echo "Repo: $repo "
echo "target: $target"
echo "log_file: $log_file"
mkdir -p $log_dir
has_changes=false
if [ ! -e $target ]; then
  echo "no target found. Clone $repo to target"
  git clone "$repo" "$target"
  has_changes=true
  cd $target
  echo "repo checkout for the first time."
else
  cd $target
  hash=$(git rev-parse HEAD)
  git pull
  new_hash=$(git rev-parse HEAD)
  if [ "$hash" != "$new_hash" ]; then
    echo "repo has been changed."
    has_changes=true
  fi  
fi

if [ "$has_changes" = true ] ;then
  echo "run update:"
  bash ./update.sh > "$log_file"  2>&1
  if  [ $? -eq 0 ] ; then
    echo "update successful."
  else
    echo "update ends with errors: see $log_file" 
  fi
fi
echo "install finished. had changes: $has_changes "
