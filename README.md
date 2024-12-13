# Hetzner-Traffic-Manager
This script monitors the outgoing traffic of a Hetzner Cloud server. If the outgoing traffic exceeds a set limit, the server will be shut down. It uses the Hetzner Cloud API.

### Prerequisites

1. **Hetzner Cloud API Token**: You need an API token from your Hetzner Cloud account. You can generate one from [Hetzner Cloud Console](https://console.hetzner.cloud/) ([Guide](https://docs.hetzner.cloud/#getting-started)).
2. **jq**: A command-line JSON processor used to parse API responses.


#### Installation

1. Install the necessary packages, if not already done:

   ```bash
   sudo apt update -y
   sudo apt-get install jq -y
   ```

2. Download the script:

   ```bash
   wget https://raw.githubusercontent.com/JanisPlayer/Hetzner-Traffic-Manager/refs/heads/main/hetzner_traffic_manager.sh
   sudo chmod 700 ./hetzner_traffic_manager.sh
   sudo chown -R root:root ./hetzner_traffic_manager.sh
   ```
   
3. Configure the script

- Open `hetzner_traffic_manager.sh` and add your Hetzner API token and server ID in the configuration section:

   ```bash
   API_TOKEN="your-api-token"        # Your Hetzner Cloud API token
   SERVER_ID="your-server-id"        # The ID of the server to monitor
   LIMIT_TB_OFFSET=-1                # Adjusts the included traffic down (-1) or up (+1) in TB
   ```

### Usage

1. **Run the script to test**:

   After adjusting the configuration, you can run the script directly to test it:

   ```bash
   /root/hetzner_traffic_manager.sh
   ```
   
2. **Automate with Cron**:

   You can run the script regularly using Cron. Add it to your Crontab:

   ```bash
   sudo crontab -e
   ```

   Example: Run every minute:

   ```bash
   * * * * * /root/hetzner_traffic_manager.sh
   ```

   Alternative way to add via a temporary file:

   ```bash
   crontab -u root -l > /tmp/tmp_crontab && echo "* * * * * /root/hetzner_traffic_manager.sh" >> /tmp/tmp_crontab
   crontab -u root /tmp/tmp_crontab && rm /tmp/tmp_crontab

**Possible Improvements**:
- Manage multiple servers returned by the API query and match them based on their IDs.
- Apply the offset limit for each server individually, allowing for more flexible traffic monitoring across multiple servers.
- Better handling of API errors.
