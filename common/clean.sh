#!/bin/bash

HERE=$(cd $(dirname "$0") && pwd)
rm $(find "$HERE/src/" -name '*.json')

