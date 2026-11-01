#!/bin/bash
# Ansible Troubleshooting Script

echo "ANSIBLE TROUBLESHOOTING CHECKLIST"
echo "=================================="

# Check Ansible installation
echo "1. Checking Ansible installation..."
if command -v ansible >/dev/null 2>&1; then
    echo "✓ Ansible is installed: $(ansible --version | head -n1)"
else
    echo "✗ Ansible is not installed"
fi

# Check SSH key
echo ""
echo "2. Checking SSH key..."
if [[ -f ~/.ssh/ansible_key ]]; then
    echo "✓ SSH private key exists"
    echo "Key fingerprint: $(ssh-keygen -lf ~/.ssh/ansible_key)"
else
    echo "✗ SSH private key not found"
fi

# Check inventory file
echo ""
echo "3. Checking inventory file..."
if [[ -f inventories/webservers.yml ]]; then
    echo "✓ Inventory file exists"
    echo "Validating syntax..."
    if ansible-inventory -i inventories/webservers.yml --list >/dev/null 2>&1; then
        echo "✓ Inventory syntax is valid"
    else
        echo "✗ Inventory syntax error"
    fi
else
    echo "✗ Inventory file not found"
fi

# Check ansible.cfg
echo ""
echo "4. Checking Ansible configuration..."
if [[ -f ansible.cfg ]]; then
    echo "✓ ansible.cfg exists"
    echo "Current configuration:"
    ansible-config dump --only-changed
else
    echo "! ansible.cfg not found (using defaults)"
fi

# Test connectivity
echo ""
echo "5. Testing connectivity..."
echo "Running ping test..."
ansible all -m ping 2>&1 | head -20
