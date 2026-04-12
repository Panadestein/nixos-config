#!/usr/bin/env bash

cd "$HOME"/.emacs.d
mkdir -p ./lib ./snippets/irp-mode ./undo
emacs --batch \
      --eval "(require 'org-loaddefs)" \
      --eval "(setq org-resource-download-policy t)" \
      --eval '(org-babel-tangle-file "./content/index.org")'
