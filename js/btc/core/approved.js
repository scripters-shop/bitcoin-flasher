document.querySelector("#validateBtn").onclick = async () => {
    const txHash = document.querySelector("#txHash").value;
    const response = await fetch(`/validate?tx_hash=${txHash}`);
    const result = await response.json();
    document.querySelector("#result").textContent = result.valid ? "Access Granted!" : "Access Denied!";
};
