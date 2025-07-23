# TOOLS

```sh
sudo apt update && sudo apt upgrade -y

# Install nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon

# Install python 3.13
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.13-full
python3.13 --version
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1
sudo update-alternatives --config python3
python3 --version

# Install pip and latest cmake
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.13
python3 -m pip --version
pip install --upgrade cmake

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# TODO: Install clippy

# Install go and its useful packages
wget https://dl.google.com/go/go1.24.5.linux-amd64.tar.gz
sudo tar -xvf go1.24.5.linux-amd64.tar.gz
sudo mv go /usr/local
rm -rf go1.24.5.linux-amd64.tar.gz
go install github.com/charmbracelet/glow@latest
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
go install github.com/fullstorydev/grpcui/cmd/grpcui@latest

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 22
node -v
nvm current
npm -v

# Install Fonts
sudo cp /path/to/fonts/* /usr/share/fonts/truetype/dejavu/
fc-cache -fv
fc-list # now your fonts should be visible there

# Install neovim
sudo apt install -y wl-clipboard zip unzip
# TODO:

# Install neovide
sudo apt install -y curl \
    gnupg ca-certificates git \
    gcc-multilib g++-multilib cmake libssl-dev pkg-config \
    libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
    libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev \
    libxcursor-dev
cargo install --git https://github.com/neovide/neovide

# Install emscripten
# TODO:
```

