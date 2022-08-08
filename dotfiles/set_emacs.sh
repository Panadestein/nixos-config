#!/usr/bin/env bash

cd "$HOME"/.emacs.d
mkdir -p ./lib ./snippets/irp-mode ./undo
emacs --batch --eval "(require 'org-loaddefs)" --eval '(org-babel-tangle-file "./content/index.org")'
