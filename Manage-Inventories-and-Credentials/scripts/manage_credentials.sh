#!/bin/bash
# Ansible Credentials Management Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SSH_KEY_PATH="$HOME/.ssh/ansible_key"

# Function to check if SSH key exists
check_ssh_key() {
    if [[ -f "$SSH_KEY_PATH" ]]; then
        echo "✓ SSH key found at $SSH_KEY_PATH"
        return 0
    else
        echo "✗ SSH key not found at $SSH_KEY_PATH"
        return 1
    fi
}

# Function to test SSH connectivity
test_ssh_connectivity() {
    local host=$1
    local user=$2
    
    echo "Testing SSH connectivity to $user@$host..."
    
    if ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o BatchMode=yes "$user@$host" "echo 'SSH connection successful'" 2>/dev/null; then
        echo "✓ SSH connection to $host successful"
        return 0
    else
        echo "✗ SSH connection to $host failed"
        return 1
    fi
}

# Function to display key fingerprint
show_key_fingerprint() {
    if check_ssh_key; then
        echo "SSH Key Fingerprint:"
        ssh-keygen -lf "$SSH_KEY_PATH"
        echo ""
        echo "Public Key Content:"
        cat "${SSH_KEY_PATH}.pub"
    fi
}

# Main execution
case "${1:-help}" in
    "check")
        check_ssh_key
        ;;
    "test")
        if [[ -n "$2" && -n "$3" ]]; then
            test_ssh_connectivity "$2" "$3"
        else
            echo "Usage: $0 test <host> <user>"
            echo "Example: $0 test 192.168.1.10 ansible"
        fi
        ;;
    "fingerprint")
        show_key_fingerprint
        ;;
    "help"|*)
        echo "Ansible Credentials Management Script"
        echo "Usage: $0 {check|test|fingerprint|help}"
        echo ""
        echo "Commands:"
        echo "  check       - Check if SSH key exists"
        echo "  test        - Test SSH connectivity to a host"
        echo "  fingerprint - Show SSH key fingerprint and public key"
        echo "  help        - Show this help message"
        ;;
esac
