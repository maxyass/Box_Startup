############################################################
# 🚀 Mythic
############################################################

# Download Mythic
git clone https://github.com/its-a-feature/Mythic --depth 1
cd Mythic/

# Install Docker & dependencies
./install_docker_ubuntu.sh
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

# Adjust Docker restart policy & rebuild settings
sudo sed -i 's/restart: always/restart: on-failure:10/g' docker-compose.yml
sudo sed -i 's/REBUILD_ON_START="true"/REBUILD_ON_START="false"/g' .env

# Install Go (needed for some agents)
sudo apt install golang-go


############################################################
# 🪡 Rusty Needle
############################################################

# Install Rust & Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
