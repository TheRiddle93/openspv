#!/bin/zsh

# tool to update all external open source repos that we control from source
# code contained inside the master repo. for now, this means just the OpenSPV
# project.

# make sure we are in the coasian source directory
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd $dir

# get all open-source repos ("subtree" - currently only OpenSPV)
git subtree pull --prefix=open-source/openspv openspv master

# delete all non-hidden files in OpenSPV
cd $dir/open-source/openspv
rm -rf ./projects/*

# copy all files from the latest version in the repo
tarball=`npm pack ../../projects/openspv-lib`
tar -xzf $tarball
mv package ./projects/openspv-lib
rm $tarball

# update on github
version=`npm view @openspv/lib version`
git add .
git commit -m "$version"
cd $dir
git subtree push --prefix=open-source/openspv openspv master
