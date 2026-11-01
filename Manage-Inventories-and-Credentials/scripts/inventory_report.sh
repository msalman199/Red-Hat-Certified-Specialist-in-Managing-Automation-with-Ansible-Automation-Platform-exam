#!/bin/bash
# Generate Ansible Inventory Report

INVENTORY_FILE="inventories/webservers.yml"
REPORT_FILE="reports/inventory_report_$(date +%Y%m%d_%H%M%S).txt"

# Create reports directory
mkdir -p reports

# Generate report
{
    echo "========================================="
    echo "ANSIBLE INVENTORY REPORT"
    echo "Generated: $(date)"
    echo "========================================="
    echo ""
    
    echo "INVENTORY STRUCTURE:"
    echo "-------------------"
    ansible-inventory -i "$INVENTORY_FILE" --graph
    echo ""
    
    echo "ALL HOSTS LIST:"
    echo "---------------"
    ansible-inventory -i "$INVENTORY_FILE" --list
    echo ""
    
    echo "CONNECTIVITY TEST:"
    echo "------------------"
    ansible all -i "$INVENTORY_FILE" -m ping
    echo ""
    
    echo "HOST FACTS SUMMARY:"
    echo "-------------------"
    ansible all -i "$INVENTORY_FILE" -m setup -a "filter=ansible_distribution*,ansible_memtotal_mb,ansible_processor_count"
    
} > "$REPORT_FILE"

echo "Inventory report generated: $REPORT_FILE"
