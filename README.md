# Ping Monitor
A simple bash script to monitor the connectivity to your router, your ISP's gateway, and Google's DNS server.
It logs the results to a file for later analysis.

## Raspberry Pi Configuration

This guide assumes you have a Raspberry Pi set up with Raspberry Pi OS.

### Find RPI IP address

List all IPs on local network and find RPI:

```bash
sudo nmap -sn 192.168.1.0/24
```

### SSH configuration

Connect to your RPI via SSH and change SSH port:

```bash
ssh pi@<RPI_IP_ADDRESS>

sudo vi /etc/ssh/sshd_config

# Change the port number from 22 to desired port, e.g., 2222

sudo systemctl restart ssh
```

### Firewall configuration

Install and configure UFW:

```bash
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

```bash
# Install traceroute
sudo apt install traceroute

# Install screen
sudo apt install screen

# Install git
sudo apt install git
```

### Set up ping-monitor script

Pull the ping-monitor repository:

```bash
git clone https://github.com/medolino/ping-monitor.git

cd ping-monitor
```

Make the script executable:
```bash
chmod +x ping-monitor.sh
```

## Run the ping-monitor script in the background

Find your router's IP address and your ISP's first hop using traceroute:

```bash
traceroute -n 8.8.8.8
```

Start the ping-monitor script in a screen session, replacing the placeholder IP addresses in the script with your actual router and ISP gateway IPs:
```bash
# Start a new screen session named ping-monitor
screen -S ping-monitor

# Run the ping-monitor script with your router IP, ISP gateway IP, and desired sleep interval (in seconds)
./ping-monitor.sh ROUTER_IP ISP_GATEWAY SLEEP_INTERVAL 

# Detach from the screen session (press Ctrl+A, then D)

# To reattach to the screen session later, use:
screen -r ping-monitor
```

