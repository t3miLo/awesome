#!/usr/bin/env bash
#
wal-tile() {
    wal -n -i "$@"
    feh --bg-scale "$(< "${HOME}/.cache/wal/wal")"
}

wal-tile ~/Documents/wallpapers/
