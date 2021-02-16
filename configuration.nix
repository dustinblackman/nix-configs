# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  inherit (pkgs) mkYarnPackage yarn2nix;

  locals = import ./locals.nix { inherit pkgs; };

  localpkgs = {
    coc = mkYarnPackage {
      name = "coc";
      src = ./vim;
      packageJSON = ./vim/package.json;
      yarnLock = ./vim/yarn.lock;
    };

    vimPlugins = import
      (pkgs.runCommand "plugins.nix"
        {
          buildInputs = [ pkgs.nodejs-12_x ];
        } "node ${./index.js} vimPlugins --vimrc=${./vim/init.vim} --snapshot=${./vim/snapshot.vim} > $out"
      )
      {
        inherit
          pkgs;
      };
  };

  # TODO Finish this later.
  # localfuncs = {
  # template = filePath:
  # pkgs.runCommand "file"
  # {
  # buildInputs = [ pkgs.nodejs-12_x ];
  # } ''
  # echo ${builtins.toJSON locals} > locals.json
  # node ${./index.js} template --templatefile=${filePath} --locals=`pwd`/locals.json > $out
  # '';
  # };

  base16shell = pkgs.fetchFromGitHub {
    owner = "chriskempson";
    repo = "base16-shell";
    rev = "ce8e1e540367ea83cc3e01eec7b2a11783b3f9e1";
    sha256 = "1yj36k64zz65lxh28bb5rb5skwlinixxz6qwkwaf845ajvm45j1q";
  };

  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "63f299b3347aea183fc5088e4d6c4a193b334a41";
    ref = "release-20.09";
  };

  hmLib = import "${home-manager}/modules/lib" {
    inherit lib;
  };

  vim-plug = pkgs.fetchFromGitHub {
    owner = "junegunn";
    repo = "vim-plug";
    rev = "8b45742540f92ba902c97ad1d3d8862ba3305438";
    sha256 = "0ashl6qixnhgj5pnss9ri8w7fzixcsd0h4cmb2jpfrfma8s7xn3b";
  };
in
{

  imports = [
    # Include the results of the hardware scan.
    ./systems
    (import "${home-manager}/nixos")
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import
      (pkgs.fetchFromGitHub {
        owner = "nix-community";
        repo = "NUR";
        rev = "733e6aeff00dc9e3004be3b19258f829585cbcec";
        sha256 = "1699pjw5pmb5mb7z3fmixx5hh9sr0svncag9c62zrnbvkr301msk";
      })
      {
        inherit pkgs;
      };
  };

  # Boot loader animation
  # Boots so fast you never see it...
  boot.plymouth = {
    enable = true;
    theme = "${locals.plymouthTheme}";
    themePackages = [
      (pkgs.stdenv.mkDerivation {
        name = "plymouthTheme";
        src = pkgs.fetchFromGitHub {
          owner = "adi1090x";
          repo = "plymouth-themes";
          rev = "c2a068e44f476d79fcc87372ad0436d11cf65b14";
          sha256 = "0w1a6dd7d6g91vhksq2c74rkprdrfcqx98q5yrl8scl525ngmihn";
        };


        buildInputs = [ pkgs.sd ];

        installPhase = ''
          mkdir -p $out/share/plymouth/themes
          mv pack_*/* .
          rm -rf pack_*
          cp -r ${locals.plymouthTheme} $out/share/plymouth/themes/${locals.plymouthTheme}
          sd "/usr/share/plymouth/themes" "/etc/plymouth/themes" $out/share/plymouth/themes/${locals.plymouthTheme}/${locals.plymouthTheme}.plymouth
        '';
      })
    ];
  };

  # Set your time zone and locale.
  time.timeZone = "America/Montreal";
  i18n.defaultLocale = "en_US.UTF-8";

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

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
          font = "${locals.systemFont.name}"
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
          background-color = "#383c4a"
          # The password window's background color
          window-color = "#383c4a"
          # The color of the password window's border
          border-color = "#d3dae3"
          # The width of the password window's border.
          # A trailing `px` is required.
          border-width = 2px
          # The pixels of empty space around the password input.
          # Do not include a trailing `px`.
          layout-space = 15
          # The color of the text in the password input.
          password-color = "#e1eef2"
          # The background color of the password input.
          password-background-color = "#383c4a"
          # The color of the password input's border.
          password-border-color = "#000000"
          # The width of the password input's border.
          password-border-width = 0
        '';
      };
    };
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${locals.username}" = {
    isNormalUser = true;
    password = "abc"; # TODO Change on first login. Maybe validate through a post install script that the themes would
    # need
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    dmidecode
    git
    jq
    htop
    iotop
    neovim
    neovim-remote
    neofetch
    nixpkgs-fmt
    nix-prefetch-github
    ripgrep
    sd
    vim

    # Languages
    go
    nodejs-12_x
    yarn
    rustup
    python3
    pipenv
    python38Packages.pynvim

    # System Apps
    albert
    gparted
    xarchiver
    plank
    xfce.xfce4-battery-plugin
    xdotool
    xbindkeys
    xbindkeys-config

    # Apps
    spotify
    vlc

    # CLI Apps
    nur.repos.dustinblackman.gomodrun
    nur.repos.dustinblackman.fetch-hls

    # Themes.
    qogir-icon-theme
  ];

  programs.zsh.enable = true;

  # Required for plank and other stuff.
  programs.dconf.enable = true;
  # Required for plank to work.
  services.bamf.enable = true;

  fonts = {
    fonts = with pkgs; [
      ankacoder
      ankacoder-condensed
      (nerdfonts.override { fonts = [ "DroidSansMono" ]; })
      noto-fonts-emoji
      twemoji-color-font
    ];
    fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];
  };

  home-manager.users."${locals.username}" = {
    # Startup items
    home.file.".xprofile".executable = true;
    home.file.".xprofile".text = ''
      #!/usr/bin/env bash
      (xbindkeys || echo "") &
      plank &
      albert &
    '';

    # XFCE/GTK Theme.
    gtk = {
      enable = true;
      font = locals.systemFont;
      iconTheme = locals.iconTheme;
      theme = locals.theme;
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
    };
    home.activation.xfceTheme = hmLib.dag.entryAfter [ "writeBoundary" ] ''
      runChanges() {
        export DISPLAY=:0.0
        xfconf-query -c xsettings -p /Net/ThemeName -s "${locals.theme.name}"
        xfconf-query -c xsettings -p /Net/IconThemeName -s "${locals.iconTheme.name}"
        xfconf-query -c xsettings -p /Gtk/FontName -s "${locals.systemFont.name} 10"
        xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "${locals.theme.name} 10"
        xfconf-query -c xfwm4 -p /general/title_font -s "${locals.systemFont.name} 10"
        xfconf-query -c xfwm4 -p /general/button_layout -s "CHM|"
        xfconf-query -c xfwm4 -p /general/title_alignment -s "left"
        xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -s "ghostwriter"
        xfconf-query -c xfce4-panel -p /panels/panel-1/enter-opacity -s 95
        xfconf-query -c xfce4-panel -p /panels/panel-1/leave-opacity -s 95
        xfconf-query -c xfce4-session -p /general/LockCommand -s "xfce4-session-logout --switch-user"
      }
      $DRY_RUN_CMD runChanges
    '';

    # Albert
    home.file.".config/albert/albert.conf".source = ./albert.conf;

    # Plank
    home.file.".local/share/plank/themes/${locals.theme.name}/dock.theme".source = "${locals.theme.package}/share/themes/${locals.theme.name}/plank/dock.theme";
    dconf.settings."net/launchpad/plank/docks/dock1" = {
      alignment = "center";
      auto-pinning = true;
      current-workspace-only = false;
      hide-delay = 0;
      hide-mode = "intelligent";
      icon-size = 48;
      items-alignment = "center";
      lock-items = false;
      monitor = "";
      offset = 0;
      pinned-only = false;
      position = "left";
      pressure-reveal = false;
      show-dock-item = false;
      theme = "${locals.theme.name}";
      tooltips-enabled = true;
      unhide-delay = 0;
      zoom-enabled = true;
      zoom-percent = 150;
    };

    programs.firefox = {
      enable = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = ''
        rg -l \'\'
      '';
    };

    programs.kitty = {
      enable = true;
      extraConfig = (builtins.readFile ./kitty.conf);
    };

    # Neovim
    home.file."./.config/nvim/init.vim".source = ./vim/init.vim;
    home.file."./.config/nvim/coc-settings.json".source = ./vim/coc-settings.json;
    home.file.".local/share/nvim/site/autoload/plug.vim".source = "${vim-plug}/plug.vim";
    home.file.".vim/plugged".source = localpkgs.vimPlugins.dir;
    home.file.".vim/plugged".recursive = true;

    home.file.".config/coc/extensions/package.json".source = "${localpkgs.coc}/libexec/coc/deps/coc/package.json";
    home.file.".config/coc/extensions/yarn.lock".source = "${localpkgs.coc}/libexec/coc/deps/coc/yarn.lock";
    home.file.".config/coc/extensions/node_modules".source = "${localpkgs.coc}/libexec/coc/node_modules";

    programs.tmux = {
      enable = true;
      extraConfig = (builtins.readFile ./tmux.conf);
      keyMode = "vi";
      plugins = with pkgs; [
        tmuxPlugins.copycat
        tmuxPlugins.prefix-highlight
        tmuxPlugins.sensible
      ];
    };

    programs.zsh = {
      enable = true;
      prezto = {
        enable = true;
        tmux.autoStartLocal = true;
        pmodules = [
          "environment"
          "terminal"
          "editor"
          "history"
          "directory"
          "spectrum"
          "utility"
          "completion"
          "history-substring-search"
          "syntax-highlighting"
          "command-not-found"
          "git"
          "tmux"
          "prompt"
        ];
      };
      plugins = [
        {
          name = "alias-tips";
          src = pkgs.fetchFromGitHub {
            owner = "djui";
            repo = "alias-tips";
            rev = "40d8e206c6d6e41e039397eb455bedca578d2ef8";
            sha256 = "17cifxi4zbzjh1damrwi2fyhj8x0y2m2qcnwgh4i62m1vysgv9xb";
          };
        }
      ];
      initExtra = ''
        export PATH="$PATH:${localpkgs.coc}/libexec/coc/node_modules/.bin"
        export VISUAL=nvim
        export EDITOR="$VISUAL"
        export THEME="${locals.shellTheme}"
        export THEME_DASH=$(echo "$THEME" | sed 's/_/-/g')
        source "${base16shell}/scripts/${"\${THEME_DASH}"}.sh"

        function search-edit() {
          eval "$FZF_DEFAULT_COMMAND" | fzf | xargs nvr -s
        }
        zle -N search-edit
        bindkey "^P" search-edit
        function search-text-edit() {
          rg --color always -n . | fzf --ansi | awk -F ':' '{print $2 " " $1}' | read line filename; if [ ! -z "$line" ]; then nvr -s "+$line" "$filename"; fi
        }
        zle -N search-text-edit
        bindkey "^S" search-text-edit

        # ZSH
        unalias rm
        unalias cp
        unalias mv

        # Neovim helpers
        alias e='nvim'
        alias ed='nvim'
        alias er='nvim'
        alias eh='nvim'
        if [ -n "${"\${NVIM_LISTEN_ADDRESS+x}"}" ]; then
          alias e='nvr --remote-tab'
          alias ed='nvr -o'
          alias er='nvr -O'
          alias eh='nvr'
        fi

        # Git helpers
        alias gp='[[ -z $(git config "branch.$(git symbolic-ref --short HEAD).merge") ]] &&
                   git push -u origin $(git symbolic-ref --short HEAD) ||
                   git push'

        function opr() {
          open "$(git config remote.origin.url | sed 's/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/' | sed 's/\.git//g')/compare/master...$(git rev-parse --abbrev-ref HEAD)?expand=1&assignees=dustinblackman"
        }

        # Command helpers
        alias gmr='gomodrun'
        alias bn='npx babel-node'
        alias ts='npx -s zsh ts-node'
        function py() {
          pipenv run python "$@"
        }
      '';
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
