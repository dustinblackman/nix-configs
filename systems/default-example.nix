{ ... }:

# Steps:
# 1. Copy example to defaults.nix
# 2. Change paths to systems folder below.

{
  imports = [
    (import ./parallels-vm/hardware-configuration.nix)
    (import ./parallels-vm/system.nix)
  ];
}
