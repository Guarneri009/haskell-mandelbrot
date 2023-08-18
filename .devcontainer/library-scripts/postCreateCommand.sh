#!/usr/bin/env bash

set -eu

USERNAME=$(whoami)
ARCH=$(arch)
echo ${ARCH}


# Install latest GHCup
mkdir -p "$HOME/.ghcup/bin" \
    && curl -LJ "https://downloads.haskell.org/~ghcup/${ARCH}-linux-ghcup" -o "$HOME/.ghcup/bin/ghcup" \
    && chmod +x "$HOME/.ghcup/bin/ghcup"

PATH="/home/$USERNAME/.cabal/bin:/home/$USERNAME/.ghcup/bin:$PATH"

GHC_VERSION="recommended"

ghcup install ghc "${GHC_VERSION}" --set \
    && ghcup install cabal recommended --set \
    && ghcup install stack recommended --set \
    && ghcup install hls recommended --set \
    && cabal update


echo "Done!"
