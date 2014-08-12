FROM debian:unstable
MAINTAINER Rodney Lorrimar <dev@rodney.id.au>
RUN echo "deb http://http.debian.net/debian experimental main" >> /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qqy install build-essential git nodejs nodejs-legacy zlib1g-dev
RUN apt-get -qqy -t experimental install ghc cabal-install alex happy

RUN adduser rodney

COPY . /mnt/ghcjs
RUN chown -R rodney:rodney /mnt/ghcjs

USER rodney
RUN echo 'export PATH=$HOME/.cabal/bin:$PATH' >> /home/rodney/.profile
ENV HOME /home/rodney
ENV PATH /home/rodney/.cabal/bin:/usr/bin:/bin

RUN cabal update

WORKDIR /mnt/ghcjs
RUN git submodule update --init

WORKDIR /mnt/ghcjs/cabal
RUN cabal install ./Cabal ./cabal-install
RUN cabal install --help | grep ghcjs > /dev/null

WORKDIR /mnt/ghcjs
RUN cabal install ./ghcjs-prim ./haddock-internal

RUN cabal install --max-backjumps=-1 --reorder-goals ./ghcjs
RUN ghcjs-boot --dev

ENTRYPOINT /bin/bash
