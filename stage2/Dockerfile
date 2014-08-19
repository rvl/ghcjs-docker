FROM ghcjs:base
MAINTAINER Rodney Lorrimar <dev@rodney.id.au>

# this is for the crazy webkit stuff ... not yet finished

USER root
RUN apt-get -qqy --no-install-recommends install darcs libwebkitgtk-3.0-dev

USER ghcjs

RUN cabal install --ghcjs ghcjs-dom
