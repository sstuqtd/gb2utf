#!/bin/bash

cd `dirname $0`
gem build ./gb2utf.gemspec
mv *.gem dist/
