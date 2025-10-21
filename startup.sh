############################################################
# Prerequisites
############################################################

sudo apt install vim
sudo apt install make

############################################################
# 🚀 Mythic
############################################################

# Download Mythic
git clone https://github.com/its-a-feature/Mythic --depth 1
cd Mythic/

# Install Docker & dependencies
sudo ./install_docker_ubuntu.sh
sudo make
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc
sudo apt install docker-ce docker-ce-cli containerd.io

# Install C2 profiles
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/http
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/tcp
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/smb

# Install agents
sudo ./mythic-cli install github https://github.com/MythicAgents/Apollo
sudo ./mythic-cli install github https://github.com/MythicAgents/merlin
sudo ./mythic-cli install github https://github.com/MythicAgents/ghostwriter
sudo ./mythic-cli install github https://github.com/MythicAgents/bloodhound
#sudo ./mythic-cli mythic_sync install github https://github.com/GhostManager/mythic_sync

# Adjust Docker restart policy & rebuild settings
sudo sed -i 's/restart: always/restart: on-failure:10/g' docker-compose.yml
sudo sed -i 's/REBUILD_ON_START="true"/REBUILD_ON_START="false"/g' .env
sudo sed -i 's/HASURA_PORT="8080"/HASURA_PORT="8079"/' .env # Set Hasura to use port 8079 instead of 8080
sudo ./mythic-cli config set rabbitmq_bind_localhost_only false # Make the Mythic Server externally accessible
sudo ./mythic-cli config set mythic_server_bind_localhost_only false # Make the Mythic Server externally accessible

# Make the changes to the .env take effect
sudo ./mythic-cli stop
sudo ./mythic-cli start

# Save the Mythic admin default password as an evironment variable "MYTHIC_PASSWORD"
echo "export MYTHIC_ADMIN_PASSWORD=\"$(sudo ./mythic-cli config get MYTHIC_ADMIN_PASSWORD | grep MYTHIC_ADMIN_PASSWORD | awk '{print $2}')\"" | tee -a ~/.bashrc
source ~/.bashrc

# Install Go (needed for some agents)
sudo apt install golang-go

cd ..


############################################################
# 🪡 Rusty Needle
############################################################

# Install Rust & Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

## ADD CARGO BUILD GRAB HERE

############################################################
# 📝 Ghostwriter
############################################################
# Prerequisite: Install Docker Compose (currently istalled with Mythic)

# Install Ghostwriter (Markdown editor for documentation/notes)
git clone https://github.com/GhostManager/Ghostwriter.git
cd Ghostwriter
./ghostwriter-cli-linux install
sudo sed -i "s/^HASURA_GRAPHQL_SERVER_PORT='8080'/HASURA_GRAPHQL_SERVER_PORT='8078'/" .env

# Update nginx ports in production.yml
sudo sed -i 's|"0\.0\.0\.0:80:80"|"0.0.0.0:8083:80"|' production.yml && \
sudo sed -i 's|"0\.0\.0\.0:443:443"|"0.0.0.0:7444:443"|' production.yml

# Allow Ghostwriter to be accessible externally by any IP on the network
sudo ./ghostwriter-cli-linux config allowhost 0.0.0.0
# Allow the Host computer to be able to access the django server (I think - vandey told me to do this)
sudo ./ghostwriter-cli-linux config allowhost $(hostname -I | awk '{print $1}')

# Create a notes folder inside Mythic
mkdir -p ~/Mythic/ghostwriter_notes

# (Optional) Create a starter README
echo "# Mythic Operation Notes" > ~/Mythic/ghostwriter_notes/README.md
echo "export GHOSTWRITER_ADMIN_PASSWORD=\"$(sudo ./ghostwriter-cli config get ADMIN_PASSWORD | grep ADMIN_PASSWORD | awk '{print $2}')\"" | tee -a ~/.bashrc


# Alias to startup Ghostwriter with Mythic
# echo 'alias mythic-notes="ghostwriter ~/Mythic/ghostwriter_notes/README.md &"' >> ~/.bashrc
# source ~/.bashrc

# Make the changes to the .env take effect
sudo ./ghostwriter-cli-linux down
sudo ./ghostwriter-cli-linux up

cd ..


############################################################
# 🩸 BloodHound CE
############################################################
# Prerequisite: Install Docker Compose (currently istalled with Mythic)

# Download the altest release of the Bloodhound CLI
wget https://github.com/SpecterOps/bloodhound-cli/releases/latest/download/bloodhound-cli-linux-amd64.tar.gz
# Next, unpack the file
tar -xvzf bloodhound-cli-linux-amd64.tar.gz
sudo rm bloodhound-cli-linux-arm64.tar.gz

# Install bloodhound ce via the Bloodhound CLI
./bloodhound-cli install

# Save the Bloodhound default password as an evironment variable "BLOODHOUND_PASSWORD"
echo "export BLOODHOUND_ADMIN_PASSWORD=\"$(sudo ./bloodhound-cli config get default_password | grep DEFAULT_PASSWORD | awk '{print $2}')\"" | tee -a ~/.bashrc
source ~/.bashrc

# Set Blood to bind to all interfaces (externally accessible) and listen on port 8082
sudo sed -i 's|\${BLOODHOUND_HOST:-127\.0\.0\.1}:\${BLOODHOUND_PORT:-8080}:8080|\${BLOODHOUND_HOST:-0.0.0.0}:\${BLOODHOUND_PORT:-8082}:8080|' /root/.config/bloodhound/docker-compose.yml

# Bring the containers down, force an update to the docker-compose.yml and then bring the containers back up
sudo ./bloodhound-cli down
sudo ./bloodhound-cli update
sudo ./bloodhound-cli up

############################################################
# Integrating Ghostwriter with Mythic
############################################################

#sudo ./mythic-cli mythic_sync install github https://github.com/GhostManager/mythic_sync
# # Setting the Ghostwriter URL in mythic_sync .env to use the host's IP address
# sudo sed -i "s|^GHOSTWRITER_URL=.*|GHOSTWRITER_URL=\"https://$(hostname -I | awk '{print $1}')\"|" .env
