# This is a comment
FROM ubuntu:15.04
MAINTAINER Michael Palotas <michael.palotas@gridfusion.net>
RUN apt-get update && apt-get install -y ruby ruby-dev
RUN gem install sinatra
RUN apt-get install -y wget
WORKDIR /home/gridfusion
RUN wget http://goo.gl/qTy1IB
