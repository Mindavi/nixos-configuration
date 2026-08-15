#!/usr/bin/env bash

# Sometimes builds are slightly unstable, and when lots of rebuilds happen, e.g. when building content-addressed,
# it can be useful to retry a few times.
# This script keeps track of build logs and keeps retry until success (or killed).
# Make sure to monitor from time to time to prevent actually broken packages from using up CPU time and energy.

echo "Starting new build: `date --iso-8601=seconds`" >> nixos-build-log.txt

while :
do
  if [[ `nixos-rebuild build --flake '.#' --no-link --keep-going 2>&1 | tee --append nixos-build-log.txt` ]]; then
    break
  fi
  echo "Build fail, retrying..."
  sleep 1
done

echo "Build done: `date --iso-8601=seconds`" >> nixos-build-log.txt

