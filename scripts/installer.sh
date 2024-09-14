#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Ensure brew command is available in the current shell
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed."
fi

# Check if tmux is installed
if ! command -v tmux &> /dev/null
then
    echo "tmux not found. Installing tmux..."
    brew install tmux
else
    echo "tmux is already installed."
fi
