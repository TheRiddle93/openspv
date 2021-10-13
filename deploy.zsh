#!/bin/zsh

# make sure we are in the coasian source directory
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
cd $dir

lerna publish

version=`git describe --tags --exact-match`

cd $dir/js/coasian-web
echo Building coasian-web
docker build --build-arg NPM_TOKEN=${NPM_TOKEN} . -t coasian-web
docker tag coasian-web ryanxcharles/coasian-web:${version}
docker push ryanxcharles/coasian-web:${version}
echo Deploying coasian-web
ssh -t coasian-web-1 'docker kill $(docker ps -q)'
ssh -t coasian-web-1 'docker rm $(docker ps -a -q)'
ssh -t coasian-web-1 "docker run --detach -p 80:3000 ryanxcharles/coasian-web:${version}"
ssh -t coasian-web-2 'docker kill $(docker ps -q)'
ssh -t coasian-web-2 'docker rm $(docker ps -a -q)'
ssh -t coasian-web-2 "docker run --detach -p 80:3000 ryanxcharles/coasian-web:${version}"

cd $dir/js/openspv-web
echo Building openspv-web
docker build --build-arg NPM_TOKEN=${NPM_TOKEN} . -t openspv-web
docker tag openspv-web ryanxcharles/openspv-web:${version}
docker push ryanxcharles/openspv-web:${version}
echo Deploying openspv-web
ssh -t openspv-web-1 'docker kill $(docker ps -q)'
ssh -t openspv-web-1 'docker rm $(docker ps -a -q)'
ssh -t openspv-web-1 "docker run --detach -p 80:3000 ryanxcharles/openspv-web:${version}"
ssh -t openspv-web-2 'docker kill $(docker ps -q)'
ssh -t openspv-web-2 'docker rm $(docker ps -a -q)'
ssh -t openspv-web-2 "docker run --detach -p 80:3000 ryanxcharles/openspv-web:${version}"
