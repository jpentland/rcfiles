ANTIGEN="$HOME/antigen.zsh"
[ -f $ANTIGEN ] || wget -c git.io/antigen -O $ANTIGEN
source $ANTIGEN

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle pip
antigen bundle command-not-found
antigen bundle gradle
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
