# Raf's NixOS Configuration

This repository contains my personal configuration files. Structure will improve
(slowly) over time.

## Updating

Run

```sh
nix flake update
git add flake.lock
git commit -m "update flake.lock to latest upstream"
sudo nixos-rebuild switch --flake .
```
