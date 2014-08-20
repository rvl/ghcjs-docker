# Docker build for ghcjs

This Docker image is for people who would like to try
[ghcjs](https://github.com/ghcjs/ghcjs).

It will take a few hours to build. At the end you will have a system
that you can login to and run ghcjs on your project.

To use it, you will need an OS which can run
[Docker](http://docker.io).


## How to build

```
git clone https://github.com/rvl/ghcjs-docker.git
cd ghcjs-docker
docker build -t ghcjs:base .
```


## How to use it

Assuming you have your Haskell project at ``~/myproject``, start a
container with this command:

```
docker run -t -i -v $HOME/myproject:/home/ghcjs/myproject --name myproject ghcjs:base
```

From within the container, you would run commands such as:

```
cd myproject
cabal sandbox init ghcjs
cabal install --only-dependencies --ghcjs
cabal install --ghcjs
```


## GHCJS Examples

The [ghcjs-examples](https://github.com/ghcjs/ghcjs-examples) repo is
helpful to look at.

To build the ``weblog`` examples:

```
git clone https://github.com/ghcjs/ghcjs-examples.git
git clone https://github.com/ghcjs/ghcjs-jquery.git
cabal install --ghcjs ./ghcjs-jquery
cabal install --ghcjs sodium
cd ghcjs-examples/weblog
./build.sh
```


## Docker Registry Hub

If you don't want to build your own, you can get the image which I
have built from the Docker Hub.

```
docker pull rodney/ghcjs
```
