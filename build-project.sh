#
# Build Split Script
#
# This script is used to split the build to allow individual project deployments
# The passed in manifest file contains the paths to the components to be deployed
#
# Once the individual project build is verified it can be build using:
#
# find src > project-manifest-NAME.txt
#
mkdir tmp
rm -rf tmp/*
rsync -av --files-from=$1 . tmp
rm -rf src/*
cp -R tmp/src/* src/
rm -rf tmp