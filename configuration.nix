# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./home.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
 i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

services.picom.enable = true;

  # Enable PipeWire
services.pipewire.enable = true;
security.rtkit.enable = true;

# Disable PulseAudio (optional if you want to replace it)
services.pulseaudio.enable = false;

# Enable PipeWire video and media session
services.pipewire.wireplumber.enable = true;

# Enable PipeWire to replace PulseAudio
services.pipewire.pulse.enable = true;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.xserver = {
	enable = true;
        windowManager.dwm = {
		enable = true;
		package = pkgs.dwm.overrideAttrs {
			src = ./dwm;
			patches = [
				(pkgs.fetchpatch {
					url = "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff";
         				sha256 = "sha256-mrHh4o9KBZDp2ReSeKodWkCz5ahCLuE6Al3NR2r2OJg=";
})
				(pkgs.fetchpatch {
					 url = "https://dwm.suckless.org/patches/pertag/dwm-pertag-20200914-61bb8b2.diff";
          				 sha256 = "sha256-wRZP/27V7xYOBnFAGxqeJFXdoDk4K1EQMA3bEoAXr/0=";
})
				(pkgs.fetchpatch {
					url = "https://dwm.suckless.org/patches/fancybar/dwm-fancybar-20220527-d3f93c7.diff";
          				sha256 = "sha256-twTkfKjOMGZCQdxHK0vXEcgnEU3CWg/7lrA3EftEAXc=";
})
		#		/etc/nixos/dwm/dwm/patches/dwm-cfacts-vanitygaps-6.4_combo.diff
];
         
};
};
	displayManager.lightdm.enable = false;
	displayManager.startx.enable = true;
  };

programs = {
   zsh = {
      enable = true;
      autosuggestions.enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

      ohMyZsh = {
         enable = true;
         theme = "robbyrussell";
         plugins = [
           "git"
           "npm"
           "history"
           "node"
           "rust"
           "deno"
         ];
      };
   };
};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.somya = {
    isNormalUser = true;
    description = "Somya";
    extraGroups = [ "networkmanager" "wheel" "git" ];
    packages = with pkgs; [
	slstatus
	dwmblocks
	fastfetch
	];
    shell = pkgs.zsh;
  };

 nixpkgs.overlays = [
	(final: prev: {
     slstatus = prev.slstatus.overrideAttrs (old: { src = /etc/nixos/slstatus ;});

	})
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    curl
    firefox
    st
    dmenu
    xorg.xrandr
    xorg.xinit
    lxappearance
    nitrogen
    xfce.thunar
    rofi
    kitty
    kdePackages.kate
    vscode
    flameshot
    zsh
    pkgs.brightnessctl
    pkgs.wireplumber
    pkgs.networkmanagerapplet
    pkgs.picom
    pkgs.scrot
    pkgs.ranger
    pkgs.zsh-powerlevel10k
    dunst
    libnotify
  ];


fonts.packages = with pkgs; [
  nerd-fonts.fira-code
  nerd-fonts.droid-sans-mono
  nerd-fonts.jetbrains-mono
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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
#  services.flatpak.enable = true;
#  xdg.portal.enable = true;
#  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk];
}
