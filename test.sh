#!/bin/sh
TAG=$(echo "$1" | sed 's/ /_/g')
echo "${TAG}"
