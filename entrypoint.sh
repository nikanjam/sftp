#!/bin/sh

# Set the root user's password from the ROOT_PASSWORD environment variable
if [ -n "$ROOT_PASSWORD" ]; then
  echo "root:${ROOT_PASSWORD}" | chpasswd
fi

# Set the www-data user's password from the WWW_DATA_PASSWORD environment variable
if [ -n "$ROOT_PASSWORD" ]; then
  echo "www-data:${ROOT_PASSWORD}" | chpasswd
fi

# Ensure the www-data user owns /var/www/html
chown -R www-data:www-data /var/www/html

# Configure SSH for SFTP and limit access to /var/www/html
{
  echo 'PasswordAuthentication yes'
  echo 'AllowTcpForwarding no'
  echo 'Match User www-data'
  echo '  ChrootDirectory %h'
  echo '  AllowTcpForwarding no'
  echo '  PermitTunnel no'
  echo '  AllowAgentForwarding no'
  echo '  X11Forwarding no'
  } >> /etc/ssh/sshd_config

chown root. /var/www/html 
chown root. /var/www

chmod 755 /var/www/html
chmod 755 /var/www

# Start the SSH server
exec /usr/sbin/sshd -D -e
