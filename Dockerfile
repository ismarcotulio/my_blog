From alpine:latest

# update and upgrade packages
RUN apk update

# installing Jekyll Requirements
RUN apk add ruby-dev \
&&  apk add build-base

# installing jekyll and bundle gems
RUN gem install jekyll bundler
