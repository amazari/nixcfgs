{config, pkgs, ...}:
{
  imports = [
    ./embedded-dev.nix
    ./java-dev.nix
    ./nix-dev.nix
  ];
  environment.systemPackages = with pkgs; [
    autoconf
    autogen
    automake
    bison
    boehmgc
    clang
    cmake
    darcs
    subversion
    monotone
    mercurial
    gcc
    gdb
    (with gitAndTools; [
      gitFull
      topGit
      gitAnnex
    ])
    tkcvs
    pythonPackages.autopep8
  ];
}
