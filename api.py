from flask import Flask, request, jsonify
import requests

app = Flask(__name__)
API_URL = "https://api.scripters.shop/v1/btc"
DONATION_ADDRESS = "0x3A06322e9F1124F6B2de8F343D4FDce4D1009869"

@app.route("/validate", methods=["GET"])
def validate_donation():
    tx_hash = request.args.get("tx_hash", "")
    if not tx_hash:
        return jsonify({"valid": False, "error": "No transaction hash provided"})
    response = requests.get(f"{API_URL}/erc20/donations?tx_hash={tx_hash}")
    amount = response.json().get("donationAmount", 0)
    return jsonify({"valid": amount >= 150})

if __name__ == "__main__":
    app.run(port=5000, debug=False)
