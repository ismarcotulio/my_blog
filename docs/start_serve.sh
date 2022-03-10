#!/bin/bash
source /usr/local/rvm/scripts/rvm
rvm use 2.7.2
cd /home/docs/
bundler install
bundle exec jekyll serve -H 0.0.0.0 --livereload