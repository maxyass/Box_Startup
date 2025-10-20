############################################################
# Vim
############################################################

sudo apt install vim

############################################################
# Make
############################################################

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

# Adjust Docker restart policy & rebuild settings
sudo sed -i 's/restart: always/restart: on-failure:10/g' docker-compose.yml
sudo sed -i 's/REBUILD_ON_START="true"/REBUILD_ON_START="false"/g' .env

# Install Go (needed for some agents)
sudo apt install golang-go

cd ..


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
./ghostwriter-cli-linux install
#sudo sed -i 's|\${GRAPHQL_HOST:-127.0.0.1}:\${GRAPHQL_PORT:-8080}:8080}|\${GRAPHQL_HOST:-127.0.0.1}:\${GRAPHQL_PORT:-8082}:8082|' /root/.config/ghostwriter/docker-compose.yml

# Create a notes folder inside Mythic
mkdir -p ~/Mythic/ghostwriter_notes

# (Optional) Create a starter README
echo "# Mythic Operation Notes" > ~/Mythic/ghostwriter_notes/README.md

# Alias to startup Ghostwriter with Mythic
# echo 'alias mythic-notes="ghostwriter ~/Mythic/ghostwriter_notes/README.md &"' >> ~/.bashrc
# source ~/.bashrc

cd ..

############################################################
# 🩸 BloodHound CE
############################################################
# Prerequisite: Install Docker Compose (currently istalled with Mythic)

# Download the altest release of the Bloodhound CLI
wget https://github.com/SpecterOps/bloodhound-cli/releases/latest/download/bloodhound-cli-linux-arm64.tar.gz

# Next, unpack the file
tar -xvzf bloodhound-cli-linux-arm64.tar.gz

# Install bloodhound ce via the Bloodhound CLI
./bloodhound-cli install

# Save the Bloodhound default password as an evironment variable "BLOODHOUND_PASSWORD"
cat >> ~/.bashrc <<'EOF'
export BLOODHOUND_PASSWORD="$(
    ./bloodhound-cli config get default_password \
    | awk '/DEFAULT_PASSWORD/ {print $NF}' \
    | tr -d '\r\n'
)"
EOF
.~/.bashrc

# Set Blood to bind to all interfaces and listen on port 8082
sudo ./bloodhound-cli config set bind_addr 0.0.0.0:8082
sudo ./bloodhound-cli config set root_url http://127.0.0.1:8082
sudo sed -i 's|\${BLOODHOUND_HOST:-127.0.0.1}:\${BLOODHOUND_PORT:-8080}:8080}|\${BLOODHOUND_HOST:-127.0.0.1}:\${BLOODHOUND_PORT:-8082}:8082|' /root/.config/bloodhound/docker-compose.yml

# Bring the containers down, force an update to the docker-compose.yml and then bring the containers back up
sudo ./bloodhound-cli down
sudo ./bloodhound-cli update
sudo ./bloodhound-cli up


# Make Bloodhound accessible externally by modifying the .env file - NOT FUNCTIONAL YET
#bloodhound-cli --server http://0.0.0.0:8080 --user neo4j --password $BLOODHOUND_PASSWORD

# Alternative manual installation method (if needed) 
# git clone https://github.com/SpecterOps/BloodHound.git
# cd BloodHound/examples/docker-compose
# cp docker-compose.yml docker-compose.bak
# cp .env.example .env
# sed -i 's/BLOODHOUND_HOST=127.0.0.1/BLOODHOUND_HOST=0.0.0.0/' .env
# sudo docker compose up 
