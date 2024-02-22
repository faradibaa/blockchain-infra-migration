#!/bin/bash

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

echo "[PHASE 2 SELESAI: Cek apakah data sudah bisa diakses dengan request http]"
