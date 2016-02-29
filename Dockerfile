# This is a comment
FROM ubuntu:14.04
MAINTAINER Michael Palotas <michael.palotas@gridfusion.net>
RUN apt-get update && apt-get install -y ruby ruby-dev
RUN gem install sinatra
RUN apt-get install -y wget
