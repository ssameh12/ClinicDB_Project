CREATE DATABASE ClinicDB;
USE ClinicDB;

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Clinic (
    ClinicID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(200),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Doctor (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(100),
    PhoneNumber VARCHAR(20),
    Address VARCHAR(200),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100),
    PhoneNumber VARCHAR(20),
    Address VARCHAR(200),
    BirthDate DATE,
    Job VARCHAR(100)
);

CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY,
    AppointmentDate DATE,
    PatientID INT,
    DoctorID INT,
    StartTime TIME,
    EndTime TIME,
    Cost DECIMAL(10,2),
    Status VARCHAR(50),
    Diagnosis VARCHAR(255),

    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);