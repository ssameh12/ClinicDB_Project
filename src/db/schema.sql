-- ClinicDB schema: tables, trigger, and view.
-- This file defines structure only. Seed data lives in seed.sql.

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

CREATE TABLE Clinic (
    ClinicID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Doctor (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(200),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(200),
    BirthDate DATE,
    Job VARCHAR(100)
);

CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY,
    AppointmentDate DATE NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Cost DECIMAL(10,2) DEFAULT 0,
    Status VARCHAR(50) DEFAULT 'scheduled',
    Diagnosis VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    CHECK (EndTime > StartTime)
);

CREATE VIEW Doctor_Next_Month AS
SELECT DoctorID, COUNT(*) AS TotalAppointments
FROM Appointment
WHERE AppointmentDate >= DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01')
  AND AppointmentDate < DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01')
GROUP BY DoctorID;
