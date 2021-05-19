#!/bin/bash

docker run --restart always --name nix-docker -d -p 3022:22 lnl7/nix:ssh
