#!/bin/bash

for f in *.heic; do

magick convert "$f" "${f%.*}.jpg"

done
