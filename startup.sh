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


############################################################
# 📝 Ghostwriter
############################################################
# Prerequisite: Install Docker Compose (currently istalled with Mythic)

# Install Ghostwriter (Markdown editor for documentation/notes)
git clone https://github.com/GhostManager/Ghostwriter.git
cd Ghostwriter
./ghostwriter-cli install

# Create a notes folder inside Mythic
mkdir -p ~/Mythic/ghostwriter_notes

# (Optional) Create a starter README
echo "# Mythic Operation Notes" > ~/Mythic/ghostwriter_notes/README.md

# Alias to startup Ghostwriter with Mythic
# echo 'alias mythic-notes="ghostwriter ~/Mythic/ghostwriter_notes/README.md &"' >> ~/.bashrc
# source ~/.bashrc

############################################################
# 🩸 BloodHound CE
############################################################
# Prerequisite: Install Docker Compose (currently istalled with Mythic)

# Download the altest release of the Bloodhound CLI
wget https://github.com/SpecterOps/bloodhound-cli/releases/latest/download/bloodhound-cli-linux-amd64.tar.gz

# Next, unpack the file
tar -xvzf bloodhound-cli-linux-amd64.tar.gz

# Install bloodhound ce via the Bloodhound CLI
./bloodhound-cli install

# Alternative manual installation method (if needed) 
# git clone https://github.com/SpecterOps/BloodHound.git
# cd BloodHound/examples/docker-compose
# cp docker-compose.yml docker-compose.bak
# cp .env.example .env
# sed -i 's/BLOODHOUND_HOST=127.0.0.1/BLOODHOUND_HOST=0.0.0.0/' .env
# sudo docker compose up 

