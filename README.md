# ClinicDB Project

## Overview
This project is a Clinic Management System database built using SQL to manage clinics, doctors, patients, and appointments.

The system manages:
- Departments
- Clinics
- Doctors
- Patients
- Appointments

## Project Features
- Database creation using SQL
- ER Diagram design
- Relational schema implementation
- SQL queries for data handling
- Trigger to prevent overlapping appointments
- View for doctors’ upcoming appointments


## Project Structure

sql/
- create_tables.sql
- load_data.sql
- queries.sql
- triggers.sql

## How to Run

1. Create the database:
CREATE DATABASE ClinicDB;

2. Run sql/create_tables.sql

3. Run sql/load_data.sql

4. Run sql/queries.sql

5. Run sql/triggers.sql

## How to Install and Run the Application

# Clinic Management App

A simple clinic management system. It has a one-page web interface where you can browse departments, clinics, doctors, patients, and appointments, and book new appointments. The data is stored in a MySQL database. The web interface talks to a small Node.js API that runs on your computer.

This guide is written for someone who has **never used Node.js or MySQL before**. Just follow the steps in order.

- [What you need](#what-you-need)
- [Step 1 — Install Node.js](#step-1--install-nodejs)
- [Step 2 — Install MySQL](#step-2--install-mysql)
- [Step 3 — Copy the project to your laptop](#step-3--copy-the-project-to-your-laptop)
- [Step 4 — Configure the password file (`.env`)](#step-4--configure-the-password-file-env)
- [Step 5 — Install the project's libraries](#step-5--install-the-projects-libraries)
- [Step 6 — Create and seed the database](#step-6--create-and-seed-the-database)
- [Step 7 — Start the app](#step-7--start-the-app)
- [Day-to-day use](#day-to-day-use)
- [Troubleshooting](#troubleshooting)
- [What's inside this folder](#whats-inside-this-folder)
- [API reference (for developers)](#api-reference-for-developers)

---

## What you need

You need **two free programs** installed on the laptop:

1. **Node.js** (version 18 or newer) — runs the web app.
2. **MySQL Community Server** (version 8) — stores the clinic data.

That's it. Everything else comes with this project.

> **Time estimate:** About 20–30 minutes the first time, mostly downloads.

---

## Step 1 — Install Node.js

### Windows

1. Go to https://nodejs.org/
2. Click the big green **LTS** button to download the installer.
3. Open the downloaded `.msi` file and click **Next** through every screen, accepting the defaults. When asked whether to install "Tools for Native Modules", you can leave it **unchecked**.
4. When the installer finishes, click **Finish**.
5. **Verify it worked.** Open the Start menu, type `cmd`, and press **Enter**. In the black window that opens, type:
   ```
   node --version
   ```
   You should see something like `v22.x.x`. If you do, Node.js is installed correctly.

### macOS

1. Go to https://nodejs.org/
2. Click the green **LTS** button to download the `.pkg` installer.
3. Open the file and click through the installer.
4. To verify, open the **Terminal** app (Applications → Utilities → Terminal) and type `node --version`. You should see `v22.x.x`.

---

## Step 2 — Install MySQL

### Windows

1. Go to https://dev.mysql.com/downloads/installer/
2. Download the **MySQL Installer for Windows** (pick the larger file, around 400 MB — it works without internet during install).
3. Run the installer. When asked which products to install, choose **"Server only"** (you don't need Workbench or anything else for this app).
4. Click **Next** → **Execute** to download and install.
5. When you reach the **Type and Networking** screen, leave everything at the defaults (Standalone, port 3306).
6. When you reach the **Authentication Method** screen, choose **"Use Strong Password Encryption"** (the default).
7. On the **Accounts and Roles** screen, you'll be asked to set a **root password**.  **Write this password down.** You will need it in the next step.
8. On the **Windows Service** screen, leave the defaults and make sure **"Start the MySQL Server at System Startup"** is checked.
9. Click **Next** and **Execute** to finish the install. Close the installer.
10. **Verify it worked.** Open the Start menu, type `services.msc`, and press Enter. Look for a service called `MySQL80` (or similar). Its status should say **"Running"**. If it does, MySQL is installed and running.

### macOS

1. Go to https://dev.mysql.com/downloads/mysql/
2. Download the **DMG Archive** for your Mac (Intel or ARM/Apple Silicon).
3. Open the DMG and run the installer. Click through.
4. When asked to set a **root password**,  **write it down.**
5. Open **System Settings** → **MySQL** (it appears as a new pane). Click **Start MySQL Server** if it isn't already running.

---

## Step 3 — Copy the project to your laptop

Copy the entire `clinic-management-app` folder to your new laptop — for example, to your `Desktop`. The full path should look like:

- **Windows:** `C:\Users\YourName\Desktop\clinic-management-app`
- **macOS:** `/Users/YourName/Desktop/clinic-management-app`

You can copy via USB drive, cloud drive (Google Drive, Dropbox, OneDrive), or any method you prefer.

---

## Step 4 — Configure the password file (`.env`)

The app needs to know your MySQL password. You'll put it in a small text file called `.env`.

1. Open the project folder (the one you just copied).
2. Find the file named **`.env.example`**.
3. Make a copy of it in the same folder and rename the copy to **`.env`** (no `.example` part, just `.env`).
   -  On Windows, you may need to enable **"File name extensions"** in File Explorer (View menu) to be able to rename it properly. The full name must be exactly `.env`.
4. Open `.env` in **Notepad** (Windows) or **TextEdit** (Mac).
5. Find the line that reads:
   ```
   DB_PASSWORD=your_mysql_password_here
   ```
   Replace `your_mysql_password_here` with the MySQL root password you wrote down in Step 2. For example, if your password is `MyPass123!`, the line should look like:
   ```
   DB_PASSWORD=MyPass123!
   ```
6. Save the file and close the editor.

> Leave all the other lines (`PORT`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_NAME`) at their defaults unless someone told you to change them.

---

## Step 5 — Install the project's libraries

1. Open a terminal **inside the project folder**:
   - **Windows:** Open the folder in File Explorer, click into the address bar at the top, type `cmd`, and press Enter. A black command-prompt window will open in that folder.
   - **macOS:** Right-click the folder in Finder and choose **Services → New Terminal at Folder**.
2. In that terminal, type:
   ```
   npm install
   ```
3. Press Enter and wait. You'll see a lot of text scrolling. It typically takes 1–2 minutes. When it finishes, the terminal returns to a prompt.

> If you see a warning about "deprecated" packages, that's normal — you can ignore it. Only red **error** messages need attention.

---

## Step 6 — Create and seed the database

This step creates the `ClinicDB` database in MySQL and fills it with the sample data (10 departments, 10 doctors, 11 patients, 10 appointments).

In the **same terminal** as before, type:

```
npm run db:setup
```

You should see output like:

```
Clinic Management — database setup
-----------------------------------
Host:     localhost:3306
User:     root
Database: ClinicDB

→ Dropping and recreating database "ClinicDB"...
→ Applying schema (tables + view)...
→ Inserting seed data...
→ Installing overlap-prevention trigger...

Database is ready.
  Departments:  10
  Clinics:      10
  Doctors:      10
  Patients:     11
  Appointments: 10

Next step: npm start
```

If you see this, the database is ready. 

>  Running `npm run db:setup` **deletes the existing database and recreates it from scratch.** Do not run it again unless you want to wipe everything and start over.

If something goes wrong, jump to [Troubleshooting](#troubleshooting).

---

## Step 7 — Start the app

In the same terminal:

```
npm start
```

You'll see:

```
Clinic app running on http://localhost:3001
```

Open your web browser (Chrome, Edge, Firefox, Safari) and go to:

**http://localhost:3001**

The clinic management interface should appear, showing the departments, doctors, patients, and appointments.

> Leave the terminal window open while you use the app. **Closing the terminal stops the app.**
> To stop the app on purpose, click the terminal window and press **Ctrl + C** (on Mac: **Control + C**).

---

## Day-to-day use

Once everything is installed, you only need to do this on subsequent days:

1. Open a terminal in the project folder (see Step 5).
2. Run:
   ```
   npm start
   ```
3. Open http://localhost:3001 in your browser.
4. When you're done, press **Ctrl + C** in the terminal to stop the app.

You do **not** need to repeat the install, the database setup, or the `.env` configuration — those are one-time steps.

If you ever want to **reset the database back to the original sample data**, run:

```
npm run db:setup
```

To **check whether MySQL is reachable** without resetting anything:

```
npm run db:check
```

---

## Troubleshooting

### "Could not reach MySQL at localhost:3306"

MySQL isn't running.

- **Windows:** Open the Start menu → type `services.msc` → press Enter. Find `MySQL80` in the list, right-click it, and choose **Start**.
- **macOS:** Open **System Settings → MySQL** and click **Start MySQL Server**.

Then re-run the command.

### "MySQL rejected the credentials for user root"

The password in your `.env` file doesn't match the MySQL root password.

- Open `.env` in Notepad/TextEdit.
- Verify `DB_PASSWORD=` is followed by the exact password you set during MySQL installation.
- No quotation marks. No spaces around the `=` sign.
- Save and retry.

### "Database 'ClinicDB' does not exist" (when running `npm start`)

You haven't run the database setup yet. Run:

```
npm run db:setup
```

### "node is not recognized" / "command not found: node"

Node.js isn't installed, or your terminal opened before Node finished installing.

- Close every terminal window.
- Re-open a fresh terminal and try `node --version` again.
- If it still fails, re-install Node.js from https://nodejs.org/

### "npm is not recognized"

Same fix as the previous one — `npm` comes bundled with Node.js.

### "Port 3001 is already in use"

Another program is using port 3001 (perhaps a previous copy of this app still running).

- Close any other terminal windows that may be running the app.
- Or change the port: open `.env`, change `PORT=3001` to `PORT=3002`, save, and run `npm start` again. Then visit http://localhost:3002.

### The browser shows "This site can't be reached"

- Make sure the terminal window running `npm start` is still open.
- Make sure you typed the URL with `http://` (not `https://`).
- Try `http://127.0.0.1:3001` instead of `localhost`.

### I want to start completely fresh

```
npm run db:setup
```

This drops the database and recreates it with the original sample data.

---

## What's inside this folder

```
clinic-management-app/
├── README.md             ← this file
├── package.json          ← project metadata + npm scripts
├── server.js             ← the Node.js web server / API
├── .env.example          ← template for the password file
├── .env                  ← your password file (you create this in Step 4)
├── public/
│   └── index.html        ← the one-page web interface
├── db/
│   ├── schema.sql        ← table definitions and the view
│   ├── seed.sql          ← the sample data (departments, doctors, patients, appointments)
│   └── trigger.sql       ← the appointment-overlap-prevention trigger
├── scripts/
│   ├── setup-db.js       ← Node script that creates + seeds the database
│   └── check-db.js       ← Node script that checks the database is reachable
└── setup.sql             ← combined schema+seed for direct MySQL CLI use (optional)
```

### What the database contains

The seed data includes:

| Table        | Rows | Examples                                           |
|--------------|------|----------------------------------------------------|
| Department   | 10   | Cardiology, Neurology, Orthopedics, Pediatrics, … |
| Clinic       | 10   | Heart Clinic, Brain Clinic, Bone Clinic, …        |
| Doctor       | 10   | Dr Ahmed (Cardiology), Dr Mona (Neurology), …     |
| Patient      | 11   | Ahmed Ali, Sara Mohamed, Shahd Sameh, …           |
| Appointment  | 10   | Various sample bookings across 2025–2026          |

The `Appointment` table has a database **trigger** that automatically refuses any new appointment that overlaps with an existing one for the same doctor on the same day.

There's also a **view** called `Doctor_Next_Month` that shows total appointments per doctor for the upcoming month.

---

## API reference (for developers)

The server exposes these HTTP endpoints under `http://localhost:3001`:

| Method | Path                              | Purpose                                   |
|--------|-----------------------------------|-------------------------------------------|
| GET    | `/api/health`                     | Liveness check                            |
| GET    | `/api/stats`                      | Counts of departments/doctors/patients/appointments |
| GET    | `/api/departments`                | List departments with clinic & doctor counts |
| GET    | `/api/clinics`                    | List clinics                              |
| GET    | `/api/doctors`                    | List doctors                              |
| GET    | `/api/patients`                   | List patients                             |
| GET    | `/api/appointments`               | List all appointments (joined)            |
| POST   | `/api/appointments`               | Create a new appointment                  |
| PATCH  | `/api/appointments/:id/status`    | Update an appointment's status            |
| DELETE | `/api/appointments/:id`           | Delete an appointment                     |
| POST   | `/api/ai/validate-booking`        | Validate a booking before submission      |
| POST   | `/api/ai/query`                   | Convert a question to a SQL query (rule-based) |
| POST   | `/api/query/run`                  | Run a read-only SELECT query and return rows |

The `/api/query/run` endpoint only accepts a single `SELECT` statement — `INSERT`, `UPDATE`, `DELETE`, and multi-statement queries are rejected.


 ## Notes
- Run files in order
- Make sure database is created first
