#!/bin/bash
set -e

echo "=== Instalacao do Gemini CLI ==="

if [ ! -d "/home/as/.nvm" ]; then
  echo "[1/3] Instalando nvm..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
source ~/.nvm/nvm.sh

echo "[2/3] Instalando Node.js LTS..."
nvm install --lts
nvm use --lts

echo "[3/3] Instalando Gemini CLI..."
npm install -g @google/gemini-cli

if [ -z "" ]; then
  read -p "Cole sua chave da API do Gemini: " chave
  echo "export GEMINI_API_KEY=""" >> ~/.bashrc
  export GEMINI_API_KEY=""
fi

echo ""
echo "=== Testando conexao ==="
echo "Ola Gemini, tudo funcionando?" | gemini
echo ""
echo "=== Instalacao concluida com sucesso! ==="
