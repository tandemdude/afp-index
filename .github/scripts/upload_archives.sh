#!/bin/bash

counter=0

# Iterate over each .zip archive
for archive in archives/*.zip; do
  # Check if there are any .zip files in the directory
  if [ ! -e "$archive" ]; then
    echo "No .zip files found in the directory."
    exit 1
  fi

  gh release upload $TAG_NAME "$archive#$(basename $archive)" \
    || (echo "Archive $(basename archive) upload failed" && exit 1)

  # Increment the counter
  ((counter++))

  # Check if 50 files have been uploaded, then wait for 80 seconds to allow the
  # GitHub rate limit to reset
  if (( counter % 50 == 0 )); then
    echo "Uploaded $counter files. Sleeping for 80 seconds..."
    sleep 80
  fi

  if (( counter % 400 == 0)); then
    echo "Sleeping an additional hour due to hourly rate-limit..."
    sleep 4200
done

echo "All files have been uploaded!"
