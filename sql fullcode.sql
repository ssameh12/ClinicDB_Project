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
-- =========================
-- 3. DEPARTMENT DATA
-- =========================
INSERT INTO Department VALUES (1, 'Cardiology');
INSERT INTO Department VALUES (2, 'Neurology');
INSERT INTO Department VALUES (3, 'Orthopedics');
INSERT INTO Department VALUES (4, 'Dermatology');
INSERT INTO Department VALUES (5, 'Pediatrics');
INSERT INTO Department VALUES (6, 'ENT');
INSERT INTO Department VALUES (7, 'Gastroenterology');
INSERT INTO Department VALUES (8, 'Urology');
INSERT INTO Department VALUES (9, 'Oncology');
INSERT INTO Department VALUES (10, 'Psychiatry');

-- =========================
-- 4. CLINIC DATA
-- =========================

INSERT INTO Clinic VALUES (1, 'Heart Clinic', 'Cairo Street 1', 1);
INSERT INTO Clinic VALUES (2, 'Brain Clinic', 'Cairo Street 2', 2);
INSERT INTO Clinic VALUES (3, 'Bone Clinic', 'Cairo Street 3', 3);
INSERT INTO Clinic VALUES (4, 'Skin Clinic', 'Cairo Street 4', 4);
INSERT INTO Clinic VALUES (5, 'Child Clinic', 'Cairo Street 5', 5);
INSERT INTO Clinic VALUES (6, 'ENT Clinic', 'Cairo Street 6', 6);
INSERT INTO Clinic VALUES (7, 'Digestive Clinic', 'Cairo Street 7', 7);
INSERT INTO Clinic VALUES (8, 'Urology Clinic', 'Cairo Street 8', 8);
INSERT INTO Clinic VALUES (9, 'Cancer Clinic', 'Cairo Street 9', 9);
INSERT INTO Clinic VALUES (10, 'Mental Clinic', 'Cairo Street 10', 10);

-- =========================
-- 5. DOCTOR DATA
-- =========================

INSERT INTO Doctor VALUES (1, 'Dr Ahmed', '0101111111', 'Nasr City', 1);
INSERT INTO Doctor VALUES (2, 'Dr Mona', '0101111112', 'Heliopolis', 2);
INSERT INTO Doctor VALUES (3, 'Dr Ali', '0101111113', 'Maadi', 3);
INSERT INTO Doctor VALUES (4, 'Dr Sara', '0101111114', 'Dokki', 4);
INSERT INTO Doctor VALUES (5, 'Dr Omar', '0101111115', '6th October', 5);
INSERT INTO Doctor VALUES (6, 'Dr Nada', '0101111116', 'Giza', 6);
INSERT INTO Doctor VALUES (7, 'Dr Youssef', '0101111117', 'Shubra', 7);
INSERT INTO Doctor VALUES (8, 'Dr Hala', '0101111118', 'Zamalek', 8);
INSERT INTO Doctor VALUES (9, 'Dr Tamer', '0101111119', 'Rehab', 9);
INSERT INTO Doctor VALUES (10, 'Dr Reem', '0101111120', 'Helwan', 10);

-- =========================
-- 6. PATIENT DATA
-- =========================

INSERT INTO Patient VALUES (1, 'Ahmed Ali', '0111111111', 'Cairo', '2000-01-01', 'Engineer');
INSERT INTO Patient VALUES (2, 'Sara Mohamed', '0111111112', 'Giza', '1999-02-02', 'Teacher');
INSERT INTO Patient VALUES (3, 'Omar Hassan', '0111111113', 'Alex', '1998-03-03', 'Student');
INSERT INTO Patient VALUES (4, 'Nour Ahmed', '0111111114', 'Cairo', '1997-04-04', 'Doctor');
INSERT INTO Patient VALUES (5, 'Mona Ali', '0111111115', 'Giza', '1996-05-05', 'Designer');
INSERT INTO Patient VALUES (6, 'Hany Mostafa', '0111111116', 'Fayoum', '1995-06-06', 'Engineer');
INSERT INTO Patient VALUES (7, 'Rana Youssef', '0111111117', 'Cairo', '1994-07-07', 'Nurse');
INSERT INTO Patient VALUES (8, 'Khaled Tarek', '0111111118', 'Alex', '1993-08-08', 'Lawyer');
INSERT INTO Patient VALUES (9, 'Laila Samir', '0111111119', 'Giza', '1992-09-09', 'Accountant');
INSERT INTO Patient VALUES (10, 'Youssef Ali', '0111111120', 'Cairo', '1991-10-10', 'Student');

-- =========================
-- 7. APPOINTMENT DATA
-- =========================

INSERT INTO Appointment VALUES (1, '2026-05-01', 1, 1, '10:00', '10:30', 500, 'scheduled', 'Fatty liver');
INSERT INTO Appointment VALUES (2, '2026-05-02', 2, 2, '11:00', '11:30', 400, 'scheduled', 'Migraine');
INSERT INTO Appointment VALUES (3, '2026-05-03', 3, 3, '12:00', '12:30', 300, 'scheduled', 'Fracture');
INSERT INTO Appointment VALUES (4, '2026-05-04', 4, 4, '13:00', '13:30', 600, 'scheduled', 'Acne');
INSERT INTO Appointment VALUES (5, '2026-05-05', 5, 5, '14:00', '14:30', 350, 'scheduled', 'Flu');
INSERT INTO Appointment VALUES (6, '2026-05-06', 6, 6, '15:00', '15:30', 450, 'scheduled', 'Allergy');
INSERT INTO Appointment VALUES (7, '2026-05-07', 7, 7, '16:00', '16:30', 700, 'scheduled', 'Ulcer');
INSERT INTO Appointment VALUES (8, '2026-05-08', 8, 8, '17:00', '17:30', 800, 'scheduled', 'Kidney stone');
INSERT INTO Appointment VALUES (9, '2026-05-09', 9, 9, '18:00', '18:30', 900, 'scheduled', 'Cancer check');
INSERT INTO Appointment VALUES (10, '2026-05-10', 10, 10, '19:00', '19:30', 1000, 'scheduled', 'Depression');

SELECT * FROM Department;
SELECT * FROM Clinic;
SELECT * FROM Doctor;
SELECT * FROM Patient;
SELECT * FROM Appointment;

SELECT DISTINCT p.Name
FROM Patient p
JOIN Appointment a ON p.PatientID = a.PatientID
WHERE a.Diagnosis = 'Fatty liver'
AND a.AppointmentDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

SELECT c.Address
FROM Clinic c
JOIN Department d ON c.DepartmentID = d.DepartmentID
WHERE d.Name = 'Cardiology';

SELECT SUM(Cost) AS TotalPaid
FROM Appointment
WHERE PatientID = 12527
AND AppointmentDate >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR);

DELIMITER //
CREATE TRIGGER check_overlapping_appointments
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Appointment
        WHERE DoctorID = NEW.DoctorID
          AND AppointmentDate = NEW.AppointmentDate
          AND NEW.StartTime < EndTime
          AND NEW.EndTime > StartTime
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Doctor has overlapping appointment';
    END IF;
END//
DELIMITER ;

CREATE VIEW Doctor_Next_Month AS
SELECT DoctorID, COUNT(*) AS TotalAppointments
FROM Appointment
WHERE MONTH(AppointmentDate) = MONTH(CURDATE()) + 1
GROUP BY DoctorID;


