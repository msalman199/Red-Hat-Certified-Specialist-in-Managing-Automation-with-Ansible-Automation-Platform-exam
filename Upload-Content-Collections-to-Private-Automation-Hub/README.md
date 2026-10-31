# My Collection

This collection provides roles and playbooks for web server management.

## Included Content

- **Roles**:
  - `webserver`: Installs and configures Apache web server

## Installation

```bash
ansible-galaxy collection install my_namespace.my_collection
Usage
- hosts: webservers
  roles:
    - my_namespace.my_collection.webserver
