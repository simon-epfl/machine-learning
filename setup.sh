#!/bin/bash

set -e

echo "Installing system dependencies..."
sudo apt update && sudo apt install -y \
  make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl \
  llvm libncursesw5-dev xz-utils tk-dev \
  libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
  git

echo "Cloning pyenv..."
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

echo "Setting up shell configuration..."
PROFILE="$HOME/.bashrc"
if [ -n "$ZSH_VERSION" ]; then
  PROFILE="$HOME/.zshrc"
fi

{
  echo ''
  echo '# >>> pyenv setup >>>'
  echo 'export PYENV_ROOT="$HOME/.pyenv"'
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
  echo 'eval "$(pyenv init --path)"'
  echo 'eval "$(pyenv init -)"'
  echo 'eval "$(pyenv virtualenv-init -)"'
  echo '# <<< pyenv setup <<<'
} >> "$PROFILE"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo "Installing Python 3.11.9..."
pyenv install 3.11.9

echo "Creating virtual environment 'myenv-311'..."
pyenv virtualenv 3.11.9 myenv-311

pyenv global myenv-311

echo ""
echo "✅ pyenv + Python 3.11.9 + virtualenv 'myenv-311' installed and activated."
echo "ℹ️ Restart your terminal or run: exec \$SHELL"

(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

sudo apt update
sudo apt install gh
