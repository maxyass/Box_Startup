// download
git clone https://github.com/its-a-feature/Mythic --depth 1
cd Mythic/

// do stupid docker stuff
./install_docker_ubuntu.sh
sudo make
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc
sudo apt install docker-ce docker-ce-cli containerd.io

// install c2 profiles
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/http
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/tcp
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/smb

// install agents
sudo ./mythic-cli install github https://github.com/MythicAgents/Apollo
sudo ./mythic-cli install github https://github.com/MythicAgents/merlin


sudo sed -I ’s/restart: always/restart: on-failure:10/g’ docker-compose.yml
sudo sed -I ’s/REBUILD_ON_START=“true”/REBUILD_ON_START=“false”/g’ .env

// install golang
sudo apt install golang-go

