#!/usr/bin/env node
// One-shot database setup: creates the database, applies schema, seeds data,
// and installs the overlap-prevention trigger. Reads credentials from .env.
//
// Run with: npm run db:setup

require('dotenv').config();

const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');

const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_PORT = Number(process.env.DB_PORT || 3306);
const DB_USER = process.env.DB_USER || 'root';
const DB_PASSWORD = process.env.DB_PASSWORD || '';
const DB_NAME = process.env.DB_NAME || 'ClinicDB';

const DB_DIR = path.join(__dirname, '..', 'db');
const SCHEMA_FILE = path.join(DB_DIR, 'schema.sql');
const SEED_FILE = path.join(DB_DIR, 'seed.sql');
const TRIGGER_FILE = path.join(DB_DIR, 'trigger.sql');

function readSql(file) {
  if (!fs.existsSync(file)) {
    throw new Error(`Required SQL file is missing: ${file}`);
  }
  return fs.readFileSync(file, 'utf8');
}

function explainError(err) {
  if (err && err.code === 'ECONNREFUSED') {
    return `Could not reach MySQL at ${DB_HOST}:${DB_PORT}. Is the MySQL service running?`;
  }
  if (err && err.code === 'ER_ACCESS_DENIED_ERROR') {
    return `MySQL rejected the credentials for user "${DB_USER}". Check DB_USER and DB_PASSWORD in your .env file.`;
  }
  if (err && err.code === 'ENOTFOUND') {
    return `MySQL host "${DB_HOST}" could not be resolved. Check DB_HOST in your .env file.`;
  }
  return err && err.message ? err.message : String(err);
}

async function main() {
  console.log('Clinic Management — database setup');
  console.log('-----------------------------------');
  console.log(`Host:     ${DB_HOST}:${DB_PORT}`);
  console.log(`User:     ${DB_USER}`);
  console.log(`Database: ${DB_NAME}`);
  console.log('');

  const connection = await mysql.createConnection({
    host: DB_HOST,
    port: DB_PORT,
    user: DB_USER,
    password: DB_PASSWORD,
    multipleStatements: true
  });

  try {
    console.log(`→ Dropping and recreating database "${DB_NAME}"...`);
    await connection.query(`DROP DATABASE IF EXISTS \`${DB_NAME}\``);
    await connection.query(`CREATE DATABASE \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`);
    await connection.query(`USE \`${DB_NAME}\``);

    console.log('→ Applying schema (tables + view)...');
    await connection.query(readSql(SCHEMA_FILE));

    console.log('→ Inserting seed data...');
    await connection.query(readSql(SEED_FILE));

    console.log('→ Installing overlap-prevention trigger...');
    await connection.query(readSql(TRIGGER_FILE));

    const [[deps]] = await connection.query('SELECT COUNT(*) AS c FROM Department');
    const [[clinics]] = await connection.query('SELECT COUNT(*) AS c FROM Clinic');
    const [[doctors]] = await connection.query('SELECT COUNT(*) AS c FROM Doctor');
    const [[patients]] = await connection.query('SELECT COUNT(*) AS c FROM Patient');
    const [[appts]] = await connection.query('SELECT COUNT(*) AS c FROM Appointment');

    console.log('');
    console.log('Database is ready.');
    console.log(`  Departments:  ${deps.c}`);
    console.log(`  Clinics:      ${clinics.c}`);
    console.log(`  Doctors:      ${doctors.c}`);
    console.log(`  Patients:     ${patients.c}`);
    console.log(`  Appointments: ${appts.c}`);
    console.log('');
    console.log('Next step: npm start');
  } finally {
    await connection.end();
  }
}

main().catch((err) => {
  console.error('');
  console.error('Database setup FAILED:');
  console.error('  ' + explainError(err));
  console.error('');
  console.error('See README.md → "Troubleshooting" for help.');
  process.exit(1);
});
