{ pkgs }:
with pkgs; [
  # Android
  android-tools
  scrcpy
  # Microprocessor
  arduino
  logisim
  micronucleus
  # C
  cmake
  gcc
  glibc
  gnumake
  # Database
  mongosh
  mysql-shell
  mysql-workbench
  # Docker
  docker-compose
  kubernetes
  kubernetes-helm
  minikube
  # Editors
  neovim
  vscodium
  # Embedded
  gcc-arm-embedded
  qemu
  # Java
  gradle
  jdk
  maven
  # Javascript
  nodejs
  # LaTeX
  texliveFull
  # Network
  wireshark
  # Python
  python3
  # Protobuf
  buf
  # Rust
  cargo
  rustc
  # Scala
  sbt
  scala_3
  # SQL
  mysql-workbench
  # Security
  binwalk
  gdb
  sasquatch
  squashfsTools
]
