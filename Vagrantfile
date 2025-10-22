# -*- mode: ruby -*-
# vi: set ft=ruby :

ARCH = `uname -m`.strip
BOX  = (ARCH == "arm64" or ARCH == "aarch64") ? "generic/ubuntu2204-arm64" : "generic/ubuntu2204"

Vagrant.configure("2") do |config|
  config.vm.box = BOX

  # keep apt fresh
  config.vm.provision "shell", inline: "sudo apt-get update", run: "once"

  # Parallels for Apple silicon
  config.vm.provider "parallels" do |prl|
    prl.cpus   = 2
    prl.memory = 2048
  end

  # (Optional) VirtualBox block is irrelevant on M1 but harmless
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = "2048"
  end

  # BGP lab packages
  config.vm.provision "shell", inline: <<-SHELL
    set -e
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y bird2 iproute2 traceroute git jq net-tools
  SHELL
end

