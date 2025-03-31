# escrow-rating-smart-contract

# Escrow Rating Smart Contract

This Solidity smart contract enables secure order payments using an escrow model, where the buyer deposits Ether and confirms delivery before the seller receives payment. It also includes a decentralized rating system where buyers can rate sellers after order completion.

## ✨ Features

- Order placement with Ether (escrow model)
- Delivery confirmation and secure seller payout
- Buyer-to-seller rating system (1 to 5 scale)
- Average rating calculation per user
- Event logging for all important actions

## 🔧 Built With

- Solidity ^0.8.0
- Compatible with Remix IDE or Hardhat

## 🧠 Concepts Demonstrated

- `struct`, `mapping`, `modifier`, `require`
- Ether transfer using `.call`
- `event` and `emit` for logging
- Defensive programming (access control, zero checks)

## 📜 License

MIT License
