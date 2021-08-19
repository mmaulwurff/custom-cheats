<!--
SPDX-FileCopyrightText: 2021 Alexander Kromm <mmaulwurff@gmail.com>

SPDX-License-Identifier: CC0-1.0
-->

# Custom Cheats

Custom Cheats is a script library for GZDoom.

Requires at least GZDoom 4.5.

## Caveats

- Custom cheats are not affected by settings that disable regular cheats.
- If a custom cheat is the same as a regular cheat, they both will have effect.

## How to Use

Downloading this repository as a ZIP file will result in a playable demo.
It has the following cheats:

- givesoul - gives soulsphere;
- shotg - gives shotgun.

To include Custom Cheats in your work:
1. Add cc_EventHandler class to your code, replacing the prefix with your own to
   avoid potential conflicts with other mods.
2. Add ??_EventHandler to gameinfo definition in mapinfo lump.

## Acknowledgments

- Thanks to Revae for bug reports.
