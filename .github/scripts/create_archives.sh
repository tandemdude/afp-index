#!/bin/bash

# File to read theory packages from
input_file="thys/ROOTS"

# Declare an empty array
theory_packages=()

# Read the file line by line
while IFS= read -r line; do
  # Trim leading/trailing whitespace
  trimmed_line=$(echo "$line" | tr -d '[:space:]')

  # Check if the line is not blank
  if [ -n "$trimmed_line" ]; then
    # Add the trimmed line to the array
    theory_packages+=("$trimmed_line")
  fi
done < "$input_file"

mkdir -p archives

pushd thys

# Create a zip archive for each theory package
for value in "${theory_packages[@]}"; do
  zip -r "../archives/${value}.zip" "${value}"
done

popd
