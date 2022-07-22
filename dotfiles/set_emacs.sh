#!/usr/bin/env bash

cd "$HOME"/.emacs.d
mkdir -p ./lib ./snippets/irp-mode ./undo
emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "./content/index.org")'
