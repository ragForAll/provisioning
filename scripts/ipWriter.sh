#!/bin/bash

# Exit immediately if any command fails.
set -e

# --- Determine Script Directory ---
# SCRIPT_DIR is the directory where this script is located.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --- Configuration ---
# Construct the full path to your Ansible inventory file relative to the script's location.
# Assuming 'inventory/hosts.ini' is a subdirectory of where the script is.
# Adjust this path if your inventory file is elsewhere relative to the script.
INVENTORY_FILE="$SCRIPT_DIR/../inventory/hosts.ini"
VARIABLES_N8N="$SCRIPT_DIR/../roles/n8n/defaults/main.yml"



# --- Main Script Logic ---

echo "🔄 Updating Ansible inventory file..."

# Verify if the IP environment variable exists and is not empty.
if [ -z "$IP" ]; then
    echo "❌ Error: The 'IP' environment variable is not not set or is empty."
    echo "Please ensure the VM IP has been extracted and exported (e.g., by sourcing 'get_vm_ip.sh')."
    exit 1
fi

# Verify if the inventory file exists at the constructed path.
if [ ! -f "$INVENTORY_FILE" ]; then
    echo "❌ Error: Inventory file not found at: $INVENTORY_FILE"
    exit 1
fi

echo "📝 Updating '$INVENTORY_FILE' with IP: $IP"

# Use 'sed' to replace the line containing 'ansible_host' with the new IP.
# A backup of the original file is created with the .bak extension for safety.
# This assumes your 'ansible_host' line looks something like "ansible_host=192.168.1.1".
sed -i.bak "s/ansible_host=[0-9.]\+/ansible_host=${IP}/" "$INVENTORY_FILE"

# Check if 'sed' command was successful.
if [ $? -ne 0 ]; then
  echo "❌ Error: Failed to update the inventory file with 'sed'."
  echo "Please check the 'sed' command and the format of your inventory file."
  exit 1
fi

echo "✅ '$INVENTORY_FILE' updated successfully with the new IP."


# Use 'sed' to replace the line containing 'ansible_host' with the new IP.
# This pattern correctly handles 'ansible_host: ' followed by any IP or no IP.
# A backup of the original file is created with the .bak extension for safety.
sed -i.bak "s/^ansible_host:[[:space:]]*[0-9.]*$/ansible_host: ${IP}/" "$VARIABLES_N8N"

# Check if 'sed' command was successful.
if [ $? -ne 0 ]; then
  echo "❌ Error: Failed to update the configuration file with 'sed'."
  echo "Please check the 'sed' command and the format of your file."
  exit 1
fi

echo "✅ '$VARIABLES_N8N' updated successfully with the new IP."

# Display the updated content of the relevant part of the inventory file for verification.
echo "--- Updated Inventory Snippet ---"
grep "ansible_host" "$INVENTORY_FILE" || echo "Note: 'ansible_host' line not found in inventory after update."
grep "ansible_host" "$VARIABLES_N8N" || echo "Note: 'ansible_host' line not found in configuration after update."
echo "------------------------------"