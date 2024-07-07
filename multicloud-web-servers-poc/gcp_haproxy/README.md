# HAProxy Setup Guide

This guide provides instructions for installing and configuring HAProxy on a Linux system. HAProxy is used for load balancing HTTP requests between multiple servers.

## Prerequisites

- A Linux server (e.g., Ubuntu)
- sudo or root access

## Installation

1. **Update your package list**:
    ```bash
    sudo apt update -y
    ```

2. **Install HAProxy**:
    ```bash
    sudo apt install haproxy -y
    ```

## Configuration

1. **Edit the HAProxy configuration file**:
    - Open the `/etc/haproxy/haproxy.cfg` file in a text editor with superuser privileges. You can use `vim` or replace it with `nano` if you prefer:
      ```bash
      sudo vim /etc/haproxy/haproxy.cfg
      ```

2. **Add the following configuration details**:
    - This configuration sets up basic logging, error handling, and defines the front-end and back-end settings for load balancing HTTP traffic.
    ```plaintext
    global
        log /dev/log local0
        log /dev/log local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

    defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

    frontend http_front
        bind *:80
        stats uri /haproxy?stats
        default_backend http_back

    backend http_back
        balance roundrobin
        # Modify the following lines to match the actual IP addresses of your web servers
        server aws_apache 192.168.1.101:80 check
        server azure_apache 192.168.1.102:80 check
    ```

3. **Save and exit** the editor.

## Managing HAProxy Service

1. **Restart HAProxy to apply the changes**:
    ```bash
    sudo systemctl restart haproxy
    ```

2. **Check the status of the HAProxy service** to ensure it is running without issues:
    ```bash
    sudo systemctl status haproxy
    ```

## Monitoring

- You can access the statistics report of HAProxy by visiting `http://<your-server-ip>/haproxy?stats` in a web browser. This page provides a real-time overview of server status and health.

## Conclusion

Following these instructions, you have successfully installed and configured HAProxy for load balancing between servers. Ensure to adjust firewall settings as needed to allow traffic on the necessary ports. Be sure to modify the server IP addresses in the configuration to reflect the actual IPs of your deployed servers.
