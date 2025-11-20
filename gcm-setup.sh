# Download GCM
cd ~/Downloads
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb

# Install pass
sudo apt install pass

# Setup GCM
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
git-credential-manager configure
git config --global credential.credentialStore gpg

# Setup gpg key
gpg --gen-key

# Initialize pass
KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep -A 1 "sec" | tail -n 1 | awk '{print $1}')
pass init "$KEY_ID"

