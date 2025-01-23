#!/bin/bash

find . -type d -name "*image*" -exec rm -rf {} \;
find . -name "*test*" -exec rm -rf {} \;
find . -type d -name ".github" -exec rm -rf {} \;
find . -name "*spec" -exec rm -rf {} \;

find . -type f -name "*.png" -delete
find . -type f -name "*.md" -delete
find . -type f -name "*.adoc" -delete
find . -type f -name ".editorconfig" -delete
find . -type f -name "*.yml" -delete
find . -type f -name "*.yaml" -delete
find . -type f -name "*.json" -delete
find . -type f -name "*.ini" -delete
