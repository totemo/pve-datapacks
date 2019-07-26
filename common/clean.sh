#!/bin/bash

HERE=$(cd $(dirname "$0") && pwd)
mkdir -p "$HERE/tmp/"
rm -f "$HERE/dist/*.zip"
find "$HERE/tmp/" -name '*.json' -exec rm {} \;
find "$HERE/src/" -name '*.json' -exec rm {} \;

