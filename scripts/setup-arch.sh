#!/bin/sh


# How to install a package?
# `pacman -Syu pkg`
# `S`   Sync/Install
# `y`   Refresh the database
# `u`   Upgrade all currently installed packages to match the new database
# `S`   ✅ Safe, but might install outdated software.
# `Sy`  ❌ DANGEROUS. Causes partial upgrades and broken dependencies.
# `Syu` ✅ THE BEST PRACTICE. Always use this.


# How to upgrade everything?
# `pacman -Syu`


# How to uninstall a package?
# `pacman -Rs pkg`
# `-R`  Remove the package.
# `-n`  Remove global configuration files (usually located in /etc/).
# `-s`  This also removes any dependencies that were installed along with this package, but only if no other installed package needs them.
# `-c`  The cascade flag removes the package, its dependencies, AND any other packages that depend on it.


# How to remove all orphaned packages at once?
# pacman -Rns $(pacman -Qtdq)


# How to list packages?
# `pacman -Qe`                              Show only explicitly installed packages.
# `pacman -Qet`                             Show only packages that are top-level (unrequired).
# `pacman -Qet > backup.txt`                Backup all packages you installed manually.
# `sudo pacman -S --needed - < backup.txt`  The `needed` flag ensures it only installs packages that aren't already on the new system.


# How find a pcakge location?
# `command -v pkg`                          Shows the path to an executable currently in your $PATH.
# `pacman -Ql pkg`                          Lists every file installed by pkg.
# `pacman -Ql pkg | grep '/usr/bin/'`       Lists only the executable commands provided by pkg.
# `pacman -Qo /path/to/file`                Tells you which package owns a specific file.


# Search for a package in the official repository?
# `pacman -Ss '^pkg' | head -20`


# How much space your explicit packages are taking up?
# `pacman -Qet | awk '{print $1}' | pacman -Qi - | grep 'Installed Size' | awk '{sum += $4} END {print sum " MB"}'`


############################################################# USER


pacman -Syu sudo
sudo --version


pacman -Syu zsh
zsh --version
zsh


useradd --create-home --shell /bin/zsh touraj # Creates user with home dir and zsh login shell
passwd touraj # Set user's password
id touraj # Verify the New User
usermod -aG wheel touraj # -aG appends wheel, -G replaces old groups with wheel
id -nG touraj # Verify group names
EDITOR=nvim visudo
# %wheel ALL=(ALL:ALL) ALL #          uncomment this line
sudo -l -U touraj # Verify wheel sudo Access (ALL : ALL) ALL
su - touraj # Switch to user sheel
whoami # Verify shows touraj
sudo whoami #Verify shows root
exit #
nvim /etc/wsl.conf # as root user open this file and append lines below to it:
# [user]
# default=touraj
exit
# `wsl --shutdown` to apply default user
# `wsl -u root` if you wanted to login as root in a session
# Open wsl again
whoami # Verify shows touraj


############################################################# TOOLS


pacman -Syu git
git --version


############################################################# LANGS


pacman -Syu gcc llvm lld clang cmake doxygen
gcc --version
llvm-config --version
lld --version
clang --version
cmake --version
doxygen --version


pacman -Syu python python-pipx
python --version
pipx --version


pacman -Syu luajit luarocks
luajit -v
pacman -Ql lua | grep '/include/.*\.h$'
luarocks config --local local_by_default true
# luarocks install --server=https://luarocks.org/m/luajit lua-cjson
# luarocks install --lua-version 5.1 lua-cjson


pacman -Syu jdk-openjdk kotlin gradle
java --version
kotlin -version
gradle --version


pacman -Syu go delve
go version
dlv version


pacman -Syu zig odin c3c
zig version
odin version
c3c -V


pacman -Syu nodejs deno bun pnpm
node --version
bun --version
deno --version
pnpm --version


pacman -Syu php composer
php --version
composer --version


pacman -Syu dotnet-sdk
dotnet --version
dotnet --list-sdks
dotnet --list-runtimes


############################################################# MISE EN PLACE


pacman -Syu mise
mise --version
mise ls
# mise use clang cmake java@25 kotlin node@26 go zig odin python
# mise use php erlang elixir
# node --version
# zig version
# odin version
# python --version
# clang --version
# cmake --version


############################################################# APPS


pacman -Syu neovim
nvim --version


pacman -Syu tmux
tmux -V


