#!/bin/bash

counter=0

# Iterate over each .zip archive
for archive in archives/*.zip; do
  # Check if there are any .zip files in the directory
  if [ ! -e "$archive" ]; then
    echo "No .zip files found in the directory."
    exit 1
  fi

  # Send POST request with the archive as the body
  echo "Uploading $archive..."
  curl -X POST -F "file=@$archive" "$url"

  curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -H "Content-Type: application/octet-stream" \
    $UPLOAD_URL \
    --data-binary "@$archive"

  # Increment the counter
  ((counter++))

  # Check if 50 files have been uploaded, then wait for 80 seconds to allow the
  # GitHub rate limit to reset
  if (( counter % 50 == 0 )); then
    echo "Uploaded $counter files. Sleeping for 80 seconds..."
    sleep 80
  fi
done

echo "All files have been uploaded!"
