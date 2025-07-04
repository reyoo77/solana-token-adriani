#!/bin/bash

# === Konfigurasi Token ===
TOKEN_NAME="ADRIANI"
TOKEN_SYMBOL="ADR"
TOTAL_SUPPLY=1000000000  # 1 Miliar
DECIMALS=9
KEYPAIR_PATH=~/.config/solana/id.json

# === Set ke jaringan Solana Devnet ===
solana config set --url https://api.devnet.solana.com
solana config set --keypair $KEYPAIR_PATH

# === Airdrop 2 SOL untuk gas ===
echo "\nMeminta 2 SOL untuk airdrop..."
solana airdrop 2

# === Buat Token Baru ===
echo "\nMembuat token SPL $TOKEN_NAME ($TOKEN_SYMBOL)..."
TOKEN_ADDRESS=$(spl-token create-token --decimals $DECIMALS | grep -oE 'Creating token .*' | awk '{print $3}')
echo "Token Address: $TOKEN_ADDRESS"

# === Buat Akun Token ===
echo "\nMembuat akun token..."
TOKEN_ACCOUNT=$(spl-token create-account $TOKEN_ADDRESS | grep -oE 'Creating account .*' | awk '{print $3}')
echo "Token Account: $TOKEN_ACCOUNT"

# === Mint Token ===
MINT_AMOUNT=$((TOTAL_SUPPLY * 10 ** DECIMALS))
echo "\nMinting $TOTAL_SUPPLY $TOKEN_SYMBOL (dengan $DECIMALS desimal)..."
spl-token mint $TOKEN_ADDRESS $MINT_AMOUNT

# === Info Token ===
echo "\nInformasi Token:"
spl-token accounts

# === Tambahan ===
echo "\nToken $TOKEN_NAME ($TOKEN_SYMBOL) berhasil dibuat di Solana Devnet!"
echo "Token Address: $TOKEN_ADDRESS"
echo "Akun Token: $TOKEN_ACCOUNT"
