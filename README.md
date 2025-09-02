# Ping Monitor
A simple bash script to monitor the connectivity to your router, your ISP's gateway, and Google's DNS server.
It logs the results to a file for later analysis.

## Raspberry Pi Configuration

This guide assumes you have a Raspberry Pi set up with Raspberry Pi OS.

### Find RPI IP address

List all IPs on local network and find RPI:

```
sudo nmap -sn 192.168.1.0/24
```

### SSH configuration

Change SSH port:

```
sudo vi /etc/ssh/sshd_config

# Change the port number from 22 to desired port, e.g., 2222

sudo systemctl restart ssh
```

### Firewall configuration

Install and configure UFW:

```
sudo apt update
sudo apt install ufw

# Blocks all unsolicited inbound connections but allows your outbound pings/updates and ssh connections
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2222/tcp

# Enable UFW
sudo ufw enable
```

### Install necessary packages

```
# Install traceroute
sudo apt install traceroute

# Install screen
sudo apt install screen

# Install git
sudo apt install git
```

### Set up ping-monitor script

Pull the ping-monitor repository:

```
git clone https://github.com/medolino/ping-monitor.git

cd ping-monitor
```

Change the IP addresses in `ping-monitor.sh` to match your network configuration:
```
# Find your router's IP address and your ISP's first hop using traceroute
traceroute -n 8.8.8.8

# Edit ping-monitor.sh and set ROUTER_IP and ISP_GATEWAY
vi ping-monitor.sh

# Make the script executable
chmod +x ping-monitor.sh
```

## Run the ping-monitor script in the background

```
# Start a new screen session named ping-monitor
screen -S ping-monitor
./ping-monitor.sh

# Detach from the screen session (press Ctrl+A, then D)
# To reattach to the screen session later, use:
screen -r ping-monitor
```

