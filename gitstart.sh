#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage $0 <project name>" >&2
    exit 1
fi 

baseDir="$HOME/projects"

echo "Checking $baseDir exists..."

if [ ! -d "$baseDir" ]; then
    echo "Creating directory $baseDir"
    mkdir "$baseDir"
fi

echo "Creating $1 directory in $baseDir..."

newDir="$baseDir/$1"

if [ ! -d "$newDir" ]; then
    mkdir "$newDir"
else
    echo "$newDir already exists" >&2
    exit 1
fi

PRIVATE=true

echo "Checking environment variables..."

if [ -z "${GITHUB_USERNAME}" ]; then
    echo "Missing environment variable GITHUB_USERNAME" >&2
    exit 1
elif [ -z "${GITHUB_PASSWORD}" ]; then
    echo "Missing environment variable GITHUB_PASSWORD" >&2
    exit 1
fi

cd "$newDir" 
# || echo "cd to $newDir failed" >&2 && exit 1

echo "Initialising git..."
git init -b main

echo "Creating README file..."
touch README.md
echo "Hello World!" >> README.md
git add README.md

# From https://www.linkedin.com/pulse/automating-github-repository-initialization-bash-script-yewale-5swif
echo "Attempting to create online repo using API..."

# echo "$GITHUB_USERNAME:$GITHUB_PASSWORD https://api.github.com/user/repos -d '{name:'$1', private: '$PRIVATE'}'"
curl -u "$GITHUB_USERNAME:$GITHUB_PASSWORD" https://api.github.com/user/repos -d '{"name":"'"$1"'", "private": '"$PRIVATE"'}'         

echo "Setting remote origin..."
git remote add origin "git@github.com:$GITHUB_USERNAME/$1.git"         

echo "Intital commit and push..."
git commit -m "Initial commit, completed by my gitstart script"
git push -f origin main

code . 