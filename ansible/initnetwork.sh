#!/bin/bash

echo "Starting run preinstall.yaml"
ansible-playbook preinstall.yaml
echo "Finished run preinstall.yaml"

echo "Starting run config.yml"
ansible-playbook config.yml
echo "Finished run config.yml"

echo "Starting run start.yaml"
ansible-playbook start.yaml
echo "Finished run start.yaml"

echo "Starting run deploycontract-edited.yml"
ansible-playbook deploycontract-edited.yml
echo "Finished run deploycontract-edited.yml"

echo "Starting run deployservices.yml"
ansible-playbook deployservices.yml
echo "Finished run deployservices.yml"
