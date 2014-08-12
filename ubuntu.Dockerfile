FROM ubuntu:trusty
MAINTAINER Rodney Lorrimar <dev@rodney.id.au>
RUN echo "deb http://ppa.launchpad.net/hvr/ghc/ubuntu precise main" >> /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qqy install build-essential git zlib1g-dev libtinfo-dev
RUN apt-get -qqy --allow-unauthenticated install ghc-7.8.3 cabal-install-1.20 alex-3.1.3 happy-1.19.4
RUN apt-get -qqy --allow-unauthenticated install nodejs

RUN adduser --disabled-password --quiet rodney

COPY . /mnt/ghcjs
WORKDIR /mnt/ghcjs
RUN git submodule update --init
RUN chown -R rodney:rodney /mnt/ghcjs

USER rodney
ENV HOME /home/rodney
ENV PATH /home/rodney/.cabal/bin:/opt/ghc/7.8.3/bin:/opt/cabal/1.20/bin:/opt/happy/1.19.4/bin:/opt/alex/3.1.3/bin:/usr/bin:/bin
ENV LANG en_AU.UTF-8

RUN cabal update

WORKDIR /mnt/ghcjs/cabal
RUN cabal install ./Cabal ./cabal-install
RUN cabal install --help | grep ghcjs > /dev/null

WORKDIR /mnt/ghcjs
RUN cabal install ./ghcjs-prim ./haddock-internal

RUN cabal install --max-backjumps=-1 --reorder-goals ./ghcjs
RUN ghcjs-boot --dev

RUN echo "export PATH=$PATH" >> $HOME/.profile
ENTRYPOINT /bin/bash
