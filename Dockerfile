FROM debian:unstable
MAINTAINER Rodney Lorrimar <dev@rodney.id.au>
RUN echo "deb http://http.debian.net/debian experimental main" >> /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qqy install build-essential git nodejs nodejs-legacy zlib1g-dev
RUN apt-get -qqy -t experimental install ghc cabal-install alex happy

RUN adduser --disabled-password --quiet rodney

COPY . /mnt/ghcjs
RUN (cd /mnt/ghcjs && git submodule update --init)
RUN chown -R rodney:rodney /mnt/ghcjs

USER rodney
ENV HOME /home/rodney
ENV PATH /home/rodney/.cabal/bin:/usr/bin:/bin

RUN cabal update

WORKDIR /mnt/ghcjs/cabal
RUN cabal install ./Cabal ./cabal-install
RUN cabal install --help | grep ghcjs > /dev/null

WORKDIR /mnt/ghcjs
RUN cabal install ./ghcjs-prim ./haddock-internal

RUN cabal install --max-backjumps=-1 --reorder-goals ./ghcjs
RUN ghcjs-boot --dev

RUN echo 'export PATH=$HOME/.cabal/bin:$PATH' >> /home/rodney/.profile
ENTRYPOINT /bin/bash
