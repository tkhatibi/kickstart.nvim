#!/bin/sh

bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

source ~/.profile

nim_enabled=false
zig_enabled=false
deno_enabled=false
bun_enabled=false
emsdk_enabled=false
lua_enabled=true

export PATH=$HOME/.config/nvim/bin:$PATH

# to run `cargo test --doc`
export PATH="$PATH:$(rustc --print target-libdir)"

# export PATH=$HOME/3rd-parties/bin:$PATH
# export PATH=$PATH:/snap/bin

alias godot4='godot4 --editor'

if [[ $lua_enabled == true ]]; then
    eval "$(luarocks path --bin)"
fi

if [[ $emsdk_enabled == true ]]; then
    source $HOME/3rd-parties/emsdk/emsdk_env.sh
    clear
fi

ODIN_ROOT=/usr/local/odin
if [ -d $ODIN_ROOT ] ; then
    export ODIN_ROOT="$ODIN_ROOT"
    export PATH=/usr/local/odin:$PATH
fi

if [[ $nim_enabled == true ]]; then
    export PATH=$HOME/.nimble/bin:$PATH
fi

if [[ $zig_enabled == true ]]; then
    export PATH="$HOME/.zig/zig-linux-x86_64-0.14.0:$PATH"
    # export PATH="$HOME/.zig/zls-linux-x86_64-0.14.0:$PATH"
fi


PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT ] ; then
    export PYENV_ROOT="$PYENV_ROOT"
    # Command below installs it. No need to run it in this file
    # curl https://pyenv.run | bash
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi


NVM_DIR="$HOME/.nvm"
if [ -d $NVM_DIR ] ; then
    export NVM_DIR="$NVM_DIR"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi


PNPM_HOME="/home/touraj/.local/share/pnpm"
if [ -d $PNPM_HOME ] ; then
    export PNPM_HOME="$PNPM_HOME"
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi


PNPM_HOME="$HOME/.local/share/pnpm"
if [ -d $PNPM_HOME ] ; then
    export PNPM_HOME="$PNPM_HOME"
    case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi


if [[ $deno_enabled == true ]]; then
    . "$HOME/.deno/env"
fi

if [[ $bun_enabled == true ]]; then
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi


GOROOT=/usr/local/go
if [ -d $GOROOT ] ; then
    export GOROOT="$GOROOT"
    export PATH=$PATH:$GOROOT/bin
fi


SDKMAN_DIR="$HOME/.sdkman"
if [ -d $SDKMAN_DIR ] ; then
    #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
    export SDKMAN_DIR="$SDKMAN_DIR"
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
# export PKG_CONFIG_PATH=$CONDA_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH

# Restore Windows commands if they were stripped by the GUI environment
if [[ -d "/mnt/c/Windows/System32" ]] && [[ ":$PATH:" != *":/mnt/c/Windows/System32:"* ]]; then
    source ~/.config/nvim/scripts/wsl.sh
    export PATH="$PATH:/mnt/c/Windows/System32"
fi
