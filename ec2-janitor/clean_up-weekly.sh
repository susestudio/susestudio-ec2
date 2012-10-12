#!/bin/bash

function run() {
  local cmd=$1
  echo `date; echo : $cmd`
  $cmd
}

# Delete all private AMIs
run "ec2-janitor.rb images --prune"

# Delete all unused snapshots older than 50 mins
run "ec2-janitor.rb snapshots --prune=50"
