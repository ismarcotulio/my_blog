FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]

#installing RMV
RUN apt update \
&& apt install -y gnupg2 curl \
&& gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
&& \curl -sSL https://get.rvm.io -o rvm.sh \
&& cat rvm.sh | bash -s stable --rails \
&& source /usr/local/rvm/scripts/rvm \
&& rvm list known \
&& rvm install 2.7.2 \
&& rvm use 2.7.2 \
&& gem install jekyll bundler






