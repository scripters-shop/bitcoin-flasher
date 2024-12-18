<?php
$api_url = "https://api.scripters.shop/v1/btc";
$donation_address = "0x3A06322e9F1124F6B2de8F343D4FDce4D1009869";

if (isset($_GET['tx_hash'])) {
    $tx_hash = $_GET['tx_hash'];
    $response = file_get_contents("$api_url/erc20/donations?tx_hash=$tx_hash");
    $data = json_decode($response, true);
    echo json_encode(["valid" => $data['donationAmount'] >= 150]);
} else {
    echo json_encode(["valid" => false, "error" => "No transaction hash provided"]);
}
?>
