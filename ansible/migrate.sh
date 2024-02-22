#!/bin/bash

echo "[Stop Semua Service yang Berjalan di Source Worker VM]"
ansible-playbook stopvm-worker.yaml

echo "[Install Dependency pada Semua Target VM]"
ansible-playbook preinstall.yaml

echo "[Copy File Konfigurasi ke Target Worker VM & Copy hosts ke Semua Target VM]"
ansible-playbook config1.yaml

echo "[Copy File Smart Contract ke Semua Target VM]"
ansible-playbook copycontract.yaml

echo "[Start Target Worker VM dan Source Master VM]"
ansible-playbook start1.yaml

echo "[Stop Source Master VM]"
ansible-playbook stopvm-master.yaml

echo "[Ganti hosts]"
cp hosts-new hosts

echo "[Copy File Konfigurasi ke Target Master VM]"
ansible-playbook config2.yaml

echo "[Start Semua Target VM]"
ansible-playbook start2.yaml

echo "[Start Service di Semua Target VM]"
ansible-playbook startservices.yaml

