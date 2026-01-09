#-----------------------------
# Panadestein's Nushell Config
#-----------------------------

$env.config = {
    show_banner: false 
    cursor_shape: {
        emacs: line
    }
}

$env.LS_COLORS = (vivid generate snazzy | str trim)

#-----------------------------
# Aliases
#-----------------------------

# Emacs
alias e = emacsclient
alias en = emacsclient -c -nw
alias cde = cd ~/.emacs.d/
alias cfe = e ~/.emacs.d/init.el

# (Neo)vim
alias v = nvim
alias cfv = vim ~/.vimrc
alias sv = sudo nvim
alias cfn = neovide --maximized ~/.config/nvim/init.vim
alias n = neovide --maximized

# Generic
alias c = code -r
alias y = yazi
alias t = trans
alias ka = killall
alias jnb = jupyter notebook
alias jour1 = journalctl -p 3 -xb
alias meteo = curl http://wttr.in
alias starwars = telnet towel.blinkenlights.nl

#-----------------------------
# Custom commands
#-----------------------------

# Fun

def cow [] {
    fortune | cowsay
}

def wo [] {
    hostname | figlet -t $in | lolcat
}

# Debugging

def jour2 [] {
    journalctl -xb | rg rror
}

def isrun [proc] {
    ps | rg $proc;
}

# Utils

def E [fil] {
    with-env [SUDO_EDITOR "emacsclient -t -a emacs"] {sudoedit $fil}
}

def poc [...col: string] {
    let redcol = $col | reduce { |it, acc| $acc + " " + $it}
    let st  = 'collections : ' | append $'"($redcol)"' | str join ' '
    papis open $"\'($st)\'"
}

def emhash [commit] {
    nix-prefetch-url --unpack $"https://github.com/Panadestein/emacsd/archive/($commit).tar.gz"
}
