#!/bin/bash

function run() {
  local cmd=$1
  echo `date; echo : $cmd`
  $cmd
}

# Terminate all instances older than 50 mins
run "ec2-janitor.rb instances --terminate=50"

# Delete all volumes older than 50 mins
run "ec2-janitor.rb volumes --prune=50"
