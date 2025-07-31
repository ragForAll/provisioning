#!/bin/bash

# Exit immediately if any command fails.
set -e

# --- Determine Script Directory ---
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# --- Configuration ---
# Construct the full path to  Ansible inventory file relative to the script's location.

INVENTORY_FILE="$SCRIPT_DIR/../inventory/hosts.ini"

PLAYBOOK_FILE="$SCRIPT_DIR/../playbooks/set_up.yml"

# --- Set Ansible Roles Path ---

export ANSIBLE_ROLES_PATH="$SCRIPT_DIR/../roles"

# --- Main Script Logic ---

echo "🚀 Starting Ansible Playbook execution..."
echo "  Inventory: $INVENTORY_FILE"
echo "  Playbook: $PLAYBOOK_FILE"
echo "  Ansible Roles Path: $ANSIBLE_ROLES_PATH" # Add this line for verification

# Execute the Ansible playbook, providing full paths to inventory and playbook.
ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK_FILE"

# Check if ansible-playbook command was successful.
if [ $? -ne 0 ]; then
  echo "❌ Error: Ansible playbook execution failed."
  echo "Please check Ansible logs for details."
  return 1
fi

echo "✅ Ansible Playbook executed successfully."