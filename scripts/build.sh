#!/bin/bash

# SPDX-FileCopyrightText: 2021 Alexander Kromm <mmaulwurff@gmail.com>
#
# SPDX-License-Identifier: CC0-1.0

mkdir -p build

filename=build/custom-cheats.pk3

rm -f "$filename"
zip -R0 "$filename" "*.md" "*.txt" "*.zs"
gzdoom  "$filename" "$@" > output 2>&1; cat output
