# Load functions
function mcd() {
    mkdir -p "$1" && cd "$1"
}


# Load aliases
[[ -f ~/.aliases ]] && source ~/.aliases
