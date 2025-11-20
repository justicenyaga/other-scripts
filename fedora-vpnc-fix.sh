# Backup symlinks
sudo cp /usr/sbin/vpnc /usr/sbin/vpnc.bak
sudo cp /usr/bin/vpnc /usr/bin/vpnc.bak

# Replace the symlinks with correct binaries
sudo ln -sf /usr/libexec/vpnc /usr/sbin/vpnc
sudo ln -sf /usr/libexec/vpnc /usr/bin/vpnc

# Set the setuid bit
sudo chmod 4755 /usr/libexec/vpnc

# Set SELinux context
sudo restorecon -v /usr/libexec/vpnc
sudo setsebool -P NetworkManager_vpnc_exec on 2>/dev/null || true

sudo tee /tmp/vpnc-real.te << EOF
module vpnc-real 1.0;
require {
        type NetworkManager_t;
        type vpnc_exec_t;
        class file { execute execute_no_trans read open };
}
#============= NetworkManager_t ==============
allow NetworkManager_t vpnc_exec_t:file { execute execute_no_trans read open };
EOF

# Install the policy
sudo checkmodule -M -m -o /tmp/vpnc-real.mod /tmp/vpnc-real.te
sudo semodule_package -o /tmp/vpnc-real.pp -m /tmp/vpnc-real.mod
sudo semodule -i /tmp/vpnc-real.pp
 
# Restart Network Manager
sudo systemctl restart NetworkManager
