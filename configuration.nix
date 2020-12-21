# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  locals = {
    username = "dustin";
  };

  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "63f299b3347aea183fc5088e4d6c4a193b334a41";
    ref = "release-20.09";
  };
in
{

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s5.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services.xserver = {
    enable = true;
    desktopManager.xfce = {
      enable = true;
      thunarPlugins = with pkgs; [
        xfce.thunar-archive-plugin
        xfce.thunar-volman
        xfce.thunar-dropbox-plugin
      ];
    };
    displayManager.defaultSession = "xfce";
    # desktopManager.plasma5.enable = true;
    # displayManager.defaultSession = "plasma5";
    displayManager.lightdm = {
      enable = true;

      greeters.mini = {
        enable = true;
        user = "${locals.username}";
        extraConfig = ''
          [greeter]
          # The user to login as.
          user = ${locals.username}
          # Whether to show the password input's label.
          show-password-label = false
          # The text of the password input's label.
          password-label-text = Password:
          # The text shown when an invalid password is entered. May be blank.
          invalid-password-text = Invalid Password
          # Show a blinking cursor in the password input.
          show-input-cursor = false
          # The text alignment for the password input. Possible values are:
          # "left" or "right"
          password-alignment = right


          [greeter-hotkeys]
          # The modifier key used to trigger hotkeys. Possible values are:
          # "alt", "control" or "meta"
          # meta is also known as the "Windows"/"Super" key
          mod-key = meta
          # Power management shortcuts (single-key, case-sensitive)
          shutdown-key = s
          restart-key = r
          hibernate-key = h
          suspend-key = u


          [greeter-theme]
          # A color from X11's `rgb.txt` file, a quoted hex string(`"#rrggbb"`) or a
          # RGB color(`rgb(r,g,b)`) are all acceptable formats.

          # The font to use for all text
          font = "Anka/Coder Regular"
          # The font size to use for all text
          font-size = 12px
          # The default text color
          text-color = "#e1eef2"
          # The color of the error text
          error-color = "#fc5571"
          # An absolute path to an optional background image.
          # The image will be displayed centered & unscaled.
          background-image = "/etc/nixos/background.jpg"
          # The screen's background color.
          background-color = "#727282"
          # The password window's background color
          window-color = "#37353a"
          # The color of the password window's border
          border-color = "#967b5e"
          # The width of the password window's border.
          # A trailing `px` is required.
          border-width = 2px
          # The pixels of empty space around the password input.
          # Do not include a trailing `px`.
          layout-space = 15
          # The color of the text in the password input.
          password-color = "#e1eef2"
          # The background color of the password input.
          password-background-color = "#37353a"
          # The color of the password input's border.
          password-border-color = "#000000"
          # The width of the password input's border.
          password-border-width = 0
        '';
      };
    };
  };


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${locals.username}" = {
    isNormalUser = true;
    password = "abc"; # TODO Change on first login. Maybe validate through a post install script that the themes would
    # need
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # TODO sort
    wget
    vim
    nixpkgs-fmt
    git
    ripgrep
    sd
    jq

    # Languages
    go
    nodejs-12_x
    rustup
    python3

    # Shell
    antibody

    # Apps
    xarchiver
    plank
  ];

  # Required for plank and other stuff.
  programs.dconf.enable = true;
  # Required for plank to work.
  services.bamf.enable = true;

  fonts.fonts = with pkgs; [
    ankacoder
    ankacoder-condensed
    (nerdfonts.override { fonts = [ "DroidSansMono" ]; })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # TODO disable
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  home-manager.users."${locals.username}" = {
    gtk = {
      enable = true;
      font = {
        package = pkgs.roboto;
        name = "Roboto Regular";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      # TODO Need a post run script to change XFCE settings.
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };
    };

    programs.firefox = {
      enable = true;
    };

    programs.kitty = {
      enable = true;
      extraConfig = ''
        background_opacity 0.85
        scrollback_lines 50000
        mouse_hide_wait 0

        macos_hide_titlebar yes
        tab_bar_edge top
        tab_bar_style fade
        active_tab_font_style   bold-italic
        inactive_tab_font_style normal

        kitty_mod cmd
        open_url_modifiers kitty_mod
        map kitty_mod+c copy_to_clipboard
        map kitty_mod+v paste_from_clipboard
        map kitty_mod+t new_tab
        map kitty_mod+w close_tab
        map kitty_mod+right next_tab
        map kitty_mod+left previous_tab
        map kitty_mod+equal change_font_size all +1.0
        map kitty_mod+minus change_font_size all -1.0

        # https://fontlibrary.org/en/font/anka-coder-condensed
        font_family Anka/Coder Condensed Regular
        font_size 14.5
        symbol_map U+e4fa-U+e52e,U+e5fa-U+e62e,U+e600-U+e6c5,U+e700-U+e7c5,U+e0a0-U+e0a2,U+e0b0-U+e0b3,U+e0a3-U+e0a3,U+e0b4-U+e0c8,U+e0ca-U+e0ca,U+e0cc-U+e0d4,U+e000-U+e00a,U+f000-U+f2e0,U+e000-U+e0a9,U+e200-U+e2a9,U+f100-U+f11c,U+f300-U+f31c,U+23fb-U+23fe,U+2b58-U+2b58,U+f000-U+f105,U+f400-U+f505,U+2665-U+2665,U+f27c-U+f27c,U+f4a9-U+f4a9,U+f001-U+f847,U+f500-U+fd46,U+f000-U+f0eb,U+e300-U+e3eb DroidSansMono Nerd Font Mono

        # https://github.com/kdrag0n/base16-kitty/blob/master/colors/base16-seti-256.conf
        background #151718
        foreground #d6d6d6
        selection_background #d6d6d6
        selection_foreground #151718
        url_color #43a5d5
        cursor #d6d6d6
        active_border_color #41535b
        active_tab_background #151718
        active_tab_foreground #d6d6d6
        inactive_tab_background #282a2b
        inactive_tab_foreground #43a5d5

        # normal
        color0 #151718
        color1 #cd3f45
        color2 #9fca56
        color3 #e6cd69
        color4 #55b5db
        color5 #a074c4
        color6 #55dbbe
        color7 #d6d6d6

        # bright
        color8 #41535b
        color9 #cd3f45
        color10 #9fca56
        color11 #e6cd69
        color12 #55b5db
        color13 #a074c4
        color14 #55dbbe
        color15 #d6d6d6

        # extended base16 colors
        color16 #db7b55
        color17 #8a553f
        color18 #282a2b
        color19 #3b758c
        color20 #43a5d5
        color21 #eeeeee
      '';
    };

    programs.neovim = {
      enable = true;
    };

    programs.rofi = {
      enable = true;
    };

    programs.zsh = {
      enable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

