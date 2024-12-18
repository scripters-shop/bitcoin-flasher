#!/bin/bash
[[ $EUID -ne 0 ]] && echo "Run as root!" && exit 1

# Install dependencies
apt update && apt install -y python3 php gcc nodejs npm solc && echo "Dependencies Installed."

# Compile C++ Server
g++ -o server server.cpp && echo "C++ Server Compiled."

# Deploy Solidity Contract
solc --bin --abi flasher.sol -o contract && echo "Solidity Contract Compiled."

# Run Python Backend and Host
python3 run.py &
php -S 0.0.0.0:8081 &
echo "Bitcoin Flasher running at:"
echo "Frontend: http://$(hostname -I | awk '{print $1}')"
echo "Python API: http://$(hostname -I | awk '{print $1}'):5000"
echo "PHP Validation: http://$(hostname -I | awk '{print $1}'):8081"
