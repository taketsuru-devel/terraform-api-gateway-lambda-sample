#!/usr/bin/env bash

if [ -d dist ]; then
  rm -rf dist
fi

# Recreate dist directory
mkdir -p dist/function/ dist/layer/

# Copy source files
echo "Copy source files"
cp -r src dist/function/

# Pack python libraries
echo "Pack python libraries"
pip install -r requirements.txt -t dist/layer/python

# Remove pycache in dist directory
find dist -type f | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm
