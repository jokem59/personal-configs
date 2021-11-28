#!/bin/bash

# Source: https://robert.kra.hn/posts/2021-02-07_rust-with-emacs/

# Install Rust
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

# Add rust source code, for use with rust-analyzer
rustup component add rust-src

# Install rust-analyzer
git clone https://github.com/rust-analyzer/rust-analyzer.git
cd rust-analyzer
cargo xtask install --server # installs rust-analyzer into $HOME/.cargo/bin
