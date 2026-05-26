#!/usr/bin/env bash
set -euo pipefail

printf "Clinic Management setup\n"
printf "=======================\n"

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is required. Install Node.js 18+ first."
  exit 1
fi

if ! command -v mysql >/dev/null 2>&1; then
  echo "MySQL client is required. Install MySQL Server/Client first."
  exit 1
fi

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi

read -r -p "MySQL user [root]: " MYSQL_USER
MYSQL_USER=${MYSQL_USER:-root}
read -r -s -p "MySQL password: " MYSQL_PASSWORD
printf "\n"

# Update .env while preserving other values.
node - <<NODE
const fs = require('fs');
let env = fs.readFileSync('.env', 'utf8');
const set = (key, value) => {
  const line = key + '=' + value;
  env = env.match(new RegExp('^' + key + '=', 'm'))
    ? env.replace(new RegExp('^' + key + '=.*', 'm'), line)
    : env + '\n' + line;
};
set('DB_USER', ${JSON.stringify(process.env.MYSQL_USER || '')} || ${JSON.stringify('${MYSQL_USER}')});
set('DB_PASSWORD', ${JSON.stringify(process.env.MYSQL_PASSWORD || '')} || ${JSON.stringify('${MYSQL_PASSWORD}')});
fs.writeFileSync('.env', env);
NODE

npm install
MYSQL_PWD="$MYSQL_PASSWORD" mysql -u "$MYSQL_USER" < setup.sql
npm start
