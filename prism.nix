{ config, pkgs, ... }:
{
  require = [
    ./hw/asrock-e350m1-fusion.nix
    ./pkgs
    ./sets/svenglish.nix
    ./user/admin.nix
    ./user/edwtjo.nix
    ./user/htpc.nix
  ];

  remote.admin.enable = true;
  remote.admin.users = [ "edwtjo" ];

  fileSystems."/" =
    { device = "/dev/mapper/cryptfs";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/sda1";
      fsType = "ext2";
    };

  fileSystems."/mnt/nfs/series" =
    { device = "nexus.q:/series";
      fsType = "nfs4";
      options = "ro";
    };

  fileSystems."/mnt/nfs/movies" =
    { device = "nexus.q:/movies";
      fsType = "nfs4";
      options = "ro";
    };

  fileSystems."/mnt/nfs/emu" =
    { device = "nexus.q:/emu";
      fsType = "nfs4";
      options = "ro";
    };

  swapDevices =[
    { device = "/dev/sda4"; }
  ];

  nix.gc.automatic = true;
  nix.gc.dates = "03:45";

  environment.variables.NIXPKGS_REPO = "/root/nixpkgs";

  environment.systemPackages = with pkgs; [
    acpi
    glxinfo
    links2
    nfsUtils
    nixin
    wine
    emulationstation
    xbmc
    wget
    git
    lshw
    vim
    xsel
    screen
    p7zip
    sshfsFuse
    gnupg
    curl
    openvpn
    sudo
    xboxdrv
    xbmc-launchers
    fceux
    zsnes
  ];

  services = {
    xserver = {
      enable = true;
      autorun = true;
      exportConfiguration = true;
      videoDrivers = [ "ati" ];
      useGlamor = true;
      resolutions = [ { x = 1280; y = 1024; } { x = 1280; y = 768; } { x = 1280; y = 720; } { x = 1024; y = 768; }];
      displayManager.slim = {
        enable = true;
        defaultUser = "htpc";
        autoLogin = true;
      };
      desktopManager = {
        xbmc.enable = true;
      };
      layout = "se";
      xkbModel = "pc105";
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };
    };
    gpm.enable = true;
    printing.enable = true;
    openssh.enable = true;
    dbus.packages = with pkgs; [ gnome.GConf ];
    locate.enable = true;
    acpid.enable = true;

    openvpn.servers = {
      hypercube = {
        config = ''
          client
          proto udp
          dev tap
          remote nexus.cube2.se 2194
          comp-lzo
          verb 3
          cipher  AES-256-CBC
          cert  /root/.vpn/hypercube/prism.crt
          key 	/root/.vpn/hypercube/prism.key
          ca 	/root/.vpn/hypercube/ca.crt
          dh	/root/.vpn/hypercube/dh4096.pem
          persist-key
          persist-tun
          status /root/.vpn/hypercube/openvpn-status.log
        '';
        autoStart = false;
      };
    };
  };

  powerManagement.enable = true;
  hardware.pulseaudio.enable = false;

  time.timeZone = "Europe/Stockholm";

  services.nixosManual.showManual = true;
  networking = {
    hostName = "prism";
    firewall.enable = false;
    #interfaceMonitor.enable = true;
    useDHCP = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.fonts = with pkgs; [
    dejavu_fonts
    corefonts
    vistafonts
    inconsolata
    anonymousPro
  ];
}
