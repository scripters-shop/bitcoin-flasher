# backend.cr - Crystal backend to handle transactions and file writing

require "kemal"
require "json"
require "time"

# Simulate the file writing of a transaction
def write_transaction_to_file(recipient, amount)
  filename = "transactions.txt"
  data = "Recipient: #{recipient}, Amount: #{amount}, Date: #{Time.local}"
  
  # Append to the file (use mode "a" for appending)
  File.open(filename, "a") do |file|
    file.puts data
  end
end

# Endpoint to simulate a transaction and write to file
post "/send_transaction" do |env|
  request = env.request.body.not_nil!
  data = JSON.parse(request)

  recipient = data["recipient"]
  amount = data["amount"]

  # Call function to write transaction to file
  write_transaction_to_file(recipient, amount)

  { status: "success", message: "Transaction recorded to file!" }.to_json
end

Kemal.run
