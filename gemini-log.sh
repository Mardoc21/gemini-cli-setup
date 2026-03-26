#!/bin/bash

# Carregar nvm e variaveis de ambiente
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -f "$HOME/.profile" ] && source "$HOME/.profile"
# Carregar chaves do arquivo .env local
ENV_FILE="$HOME/gemini-cli-setup/.env"
if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

if [ -z "$GEMINI_API_KEY" ]; then
  echo "ERRO: GEMINI_API_KEY nao definida."
  echo "Crie o arquivo: ~/gemini-cli-setup/.env"
  echo "Com o conteudo: GEMINI_API_KEY=sua_chave_aqui"
  exit 1
fi

LOG_DIR="$HOME/gemini-cli-setup/logs"
LOG_FILE="$LOG_DIR/performance-$(date +%Y-%m-%d).log"
CONTADOR_FILE="$LOG_DIR/contador-$(date +%Y-%m-%d).txt"

mkdir -p "$LOG_DIR"

# Contador diario
if [ ! -f "$CONTADOR_FILE" ]; then
  echo 0 > "$CONTADOR_FILE"
fi

TOTAL=$(cat "$CONTADOR_FILE")
TOTAL=$((TOTAL + 1))
echo $TOTAL > "$CONTADOR_FILE"

# Prompt
PROMPT="$*"
if [ -z "$PROMPT" ]; then
  read -p "Pergunta: " PROMPT
fi

# Modelo
MODELO="gemini-2.0-flash"

# Tempo de resposta
INICIO=$(date +%s%N)
RESPOSTA=$(echo "$PROMPT" | gemini 2>&1)
FIM=$(date +%s%N)
TEMPO_MS=$(( (FIM - INICIO) / 1000000 ))

# Registrar no log
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] REQ#${TOTAL} | Modelo: ${MODELO} | Tempo: ${TEMPO_MS}ms | Prompt: ${PROMPT}" >> "$LOG_FILE"

# Saida
echo ""
echo "$RESPOSTA"
echo ""
echo "--- LOG ---"
echo "Requisicao #${TOTAL} hoje | Tempo: ${TEMPO_MS}ms"
echo "Log salvo em: $LOG_FILE"
