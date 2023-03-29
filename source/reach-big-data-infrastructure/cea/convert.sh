#!/bin/sh -eux

pandoc --extract-media=. -s $1 -t rst --filter filter.hs -o index.rst