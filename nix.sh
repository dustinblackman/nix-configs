#!/usr/bin/env bash

rm /etc/nixos/configuration.nix
cp ./configuration.nix /etc/nixos/

sudo nixos-rebuild switch
