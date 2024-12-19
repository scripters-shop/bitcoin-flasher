// transaction_processor.rs - Rust program to process transactions

use std::fs::{OpenOptions};
use std::io::{Write};

fn process_transaction(recipient: &str, amount: f64) {
    let filename = "transactions_processed.txt";
    let data = format!("Recipient: {}, Amount: {:.2}, Processed at: {}\n", recipient, amount, chrono::Local::now());

    // Append to the processed transactions file
    let mut file = OpenOptions::new().append(true).create(true).open(filename).expect("Unable to open file");
    file.write_all(data.as_bytes()).expect("Unable to write data to file");
}

fn main() {
    // Example usage of processing a transaction
    let recipient = "0x1234abcd5678efgh";
    let amount = 100.0;

    process_transaction(recipient, amount);
    println!("Transaction processed and saved to file.");
}
