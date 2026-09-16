# Custom commands

def wo [] {
    hostname | figlet -t $in | lolcat
}

def isrun [proc] {
    ps | rg $proc
}

def E [fil] {
    with-env [SUDO_EDITOR "emacsclient -t -a emacs"] { sudoedit $fil }
}

def poc [...col: string] {
    let redcol = $col | reduce { |it, acc| $acc + " " + $it }
    let st = 'collections : ' | append $'"($redcol)"' | str join ' '
    papis open $"\'($st)\'"
}

def emhash [commit] {
    nix-prefetch-url --unpack $"https://github.com/Panadestein/emacsd/archive/($commit).tar.gz"
}
