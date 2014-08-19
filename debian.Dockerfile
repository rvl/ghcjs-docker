FROM debian:unstable
MAINTAINER Rodney Lorrimar <dev@rodney.id.au>
RUN echo "deb http://http.debian.net/debian experimental main" >> /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qqy install locales build-essential autoconf git nodejs nodejs-legacy zlib1g-dev
RUN apt-get -qqy -t experimental install ghc cabal-install alex happy

# either ghc-pkg dump or ghcjs-boot requires a utf-8 locale
RUN echo "LANG=en_AU.UTF-8" > /etc/default/locale
RUN echo "en_AU.UTF-8 UTF-8" > /etc/locale.gen
RUN /usr/sbin/locale-gen
ENV LANG en_AU.UTF-8

RUN adduser --disabled-password --quiet ghcjs
RUN adduser ghcjs sudo

COPY . /home/ghcjs/build

WORKDIR /home/ghcjs/build
RUN git submodule update --init
RUN chown -R ghcjs:ghcjs /home/ghcjs/build

USER ghcjs
ENV HOME /home/ghcjs
ENV PATH /home/ghcjs/.cabal/bin:/usr/bin:/bin
RUN echo "export PATH=$PATH" >> $HOME/.profile

RUN cabal update

WORKDIR /home/ghcjs/build/cabal
RUN cabal install ./Cabal ./cabal-install
RUN cabal install --help | grep ghcjs > /dev/null

WORKDIR /home/ghcjs/build
RUN cabal install ./ghcjs-prim ./haddock-internal
RUN cabal install --max-backjumps=-1 --reorder-goals ./ghcjs
RUN ghcjs-boot --dev

USER ghcjs
WORKDIR /home/ghcjs
ENTRYPOINT /bin/bash -l
