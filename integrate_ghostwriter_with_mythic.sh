sudo ./mythic-cli mythic_sync install github https://github.com/GhostManager/mythic_sync

# Fetch Ghostwriter API
# Install mythic_sync
# Follow prompts

# # Setting the Ghostwriter URL in mythic_sync .env to use the host's IP address
# sudo sed -i "s|^GHOSTWRITER_URL=.*|GHOSTWRITER_URL=\"https://$(hostname -I | awk '{print $1}'):443\"|" .env