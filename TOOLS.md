# TOOLS

```sh
sudo apt update && sudo apt upgrade -y
```

## How to Install a Desktop Environment on WSL2?

```sh
sudo apt install tasksel
sudo tasksel
# Select KDE, and press Ok
sudo apt install xrdp
ip a
# Copy the IP from `eth0.inet` and paste it in `Remote Desktop Connection`
```

## Common setup

```sh
sudo apt install -y build-essential libudev-dev libdecor-0-0 pkg-config

# [[ ZSH, OH-MY-ZSH ]]
sudo apt install zsh
echo 'source ~/.config/nvim/scripts/zshrc' > ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
chsh -s /usr/bin/zsh

# [[ NIX ]]
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
. ~/.nix-profile/etc/profile.d/nix.sh
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# [[ LUAJIT, LUAROCKS ]]
nix profile add nixpkgs#luajit nixpkgs#luarocks
luarocks config --local local_by_default true
lua -v
luarocks --version

# [[ PIP, PIPX ]]
sudo apt install python3-pip
pip --version
sudo apt install pipx
pipx --version

# [[ C, C++ ]]
nix profile add nixpkgs#llvm nixpkgs#lld nixpkgs#clang nixpkgs#clang-tools nixpkgs#cmake
nix profile add nixpkgs#cmake-language-server nixpkgs#cmake-lint nixpkgs#cmake-format
clang --version
cmake --version
clang-format --version
clang-tidy --version
clang-refactor --version
# TODO: setup emscripten

# [[ MISE ]]
nix profile add nixpkgs#mise
# cargo binstall mise
mise --version
mise use -g java@25 node@26 go zig odin kotlin
# mise use -g php erlang elixir
. ~/.zshrc
mise ls
java --version
go version
node --version
zig version
odin version
kotlin -version

# [[ RUST ]]
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install cargo-binstall
cargo install cargo-expand
cargo install ripgrep
cargo install skim
cargo install --locked bat
cargo install --locked fd-find
sudo apt install libclang-dev
cargo install --locked tree-sitter-cli
cargo component add rust-analyzer

# [[ GO ]]
wget https://dl.google.com/go/go1.26.3.linux-amd64.tar.gz
sudo tar -xvf go1.26.3.linux-amd64.tar.gz
sudo mv go /usr/local
rm -rf go1.26.3.linux-amd64.tar.gz
go install github.com/charmbracelet/glow@latest
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
go install github.com/fullstorydev/grpcui/cmd/grpcui@latest

# [[ C3 ]]
wget wget https://github.com/c3lang/c3c/releases/latest/download/c3-linux-static.tar.gz
sudo tar -xvf c3-linux-static.tar.gz
sudo mv c3 /usr/local
rm -rf c3-linux-static.tar.gz
. ~/.zshrc
c3c -V

# [[ GIT-DELTA ]]
cargo install git-delta
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global merge.conflictStyle zdiff3
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global delta.line-numbers true
# git config --global delta.dark true  # or `delta.light true`, or omit for auto-detection

# [[ NVM ]] not needed if you installed node by mise
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 26
node -v
nvm current
npm -v

# Install Fonts for XFCE terminal (not needed in WSL2 terminal)
cd ~/.config/nvim/scripts
./setup-xfce-font.sh

# [[ NEOVIM ]]
sudo apt install -y fonts-noto-color-emoji xclip
nix profile add nixpkgs#neovim

# [[ HELIX ]]
nix profile add nixpkgs#helix

# [[ TMUX ]]
nix profile add nixpkgs#tmux

# [[ NEOVIDE ]]
sudo apt install -y curl \
    gnupg ca-certificates git \
    gcc-multilib g++-multilib libssl-dev \
    libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
    libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev \
    libxcursor-dev
cargo install --git https://github.com/neovide/neovide
```

