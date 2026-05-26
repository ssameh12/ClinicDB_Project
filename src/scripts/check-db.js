#!/usr/bin/env node
// Quick health check: verifies MySQL is reachable and ClinicDB has data.
// Run with: npm run db:check

require('dotenv').config();

const mysql = require('mysql2/promise');

const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_PORT = Number(process.env.DB_PORT || 3306);
const DB_USER = process.env.DB_USER || 'root';
const DB_PASSWORD = process.env.DB_PASSWORD || '';
const DB_NAME = process.env.DB_NAME || 'ClinicDB';

async function main() {
  console.log(`Checking MySQL at ${DB_HOST}:${DB_PORT} as ${DB_USER}...`);

  const connection = await mysql.createConnection({
    host: DB_HOST,
    port: DB_PORT,
    user: DB_USER,
    password: DB_PASSWORD
  });

  try {
    const [dbs] = await connection.query(
      'SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = ?',
      [DB_NAME]
    );
    if (dbs.length === 0) {
      console.error(`Database "${DB_NAME}" does not exist. Run: npm run db:setup`);
      process.exit(1);
    }

    await connection.query(`USE \`${DB_NAME}\``);
    const [[deps]] = await connection.query('SELECT COUNT(*) AS c FROM Department');
    const [[appts]] = await connection.query('SELECT COUNT(*) AS c FROM Appointment');

    if (deps.c === 0) {
      console.error(`Database "${DB_NAME}" exists but is empty. Run: npm run db:setup`);
      process.exit(1);
    }

    console.log('Connection OK.');
    console.log(`  Departments:  ${deps.c}`);
    console.log(`  Appointments: ${appts.c}`);
  } finally {
    await connection.end();
  }
}

main().catch((err) => {
  if (err && err.code === 'ECONNREFUSED') {
    console.error(`Could not reach MySQL at ${DB_HOST}:${DB_PORT}. Is the MySQL service running?`);
  } else if (err && err.code === 'ER_ACCESS_DENIED_ERROR') {
    console.error(`MySQL rejected the credentials for user "${DB_USER}". Check your .env file.`);
  } else {
    console.error('Check failed:', err && err.message ? err.message : err);
  }
  process.exit(1);
});
