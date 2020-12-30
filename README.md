![nix-configs](.github/images/banner.png)

A series of nix configs and dotfiles for my personal NixOS setups. These configs are more for tinkering rather than everyday use, and are incomplete with lots of TODOs, but can be used as starting point for those who need (for example getting Chromebooks to work nicely).

[![image](https://i.imgur.com/ORmhG7y.jpg)](https://i.imgur.com/d66WgfO.jpg)

## Structure

- [configuration.nix](./configuration.nix) is the entry point for the entire setup, and is where the majority of configuration lives.
- [index.js](./index.js) is a series of functions to produce nix configurations that I was too lazy to figure out how to do in nix itself.
- [systems/](./systems) are configurations for specific systems, for now only containing setups for a [Parallels VM](./systems/parallels-vm) and a [Acer CB3-132 Chromebook](./systems/acer-cb3-132). System selection is hardcorded through a default.nix inside [systems](./systems), with [default-example.nix](./systems/default-example.nix) as an example.
- [iso/](./iso) contains configs for generating ISO's based on [systems](./systems) configurations. This is handy for chromebooks for example so the keyboard works when booting from a live CD.
- [vim/](./vim) is a series of vim configurations, with custom functionality for plugin management as I didn't find what Nix offered to fit my needs.
- [qogir-theme/](./qogir-theme) is the popular [Qogir GTK Theme](https://github.com/vinceliuice/Qogir-theme) but with OSX close/minimize/maximize windows buttons.
