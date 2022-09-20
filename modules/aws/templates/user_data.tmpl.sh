#!/bin/bash
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
apt-get update && apt-get install -y tailscale
tailscale up --authkey ${authkey} --advertise-exit-node --hostname=${hostname} %{ if enable_tailscale_ssh  } --ssh %{ endif } --advertise-tags=tag:exitnode --advertise-routes=${advertise_routes}
