USE ClinicDB;

-- =========================
-- DISPLAY ALL TABLES DATA
-- =========================

SELECT * FROM Department;
SELECT * FROM Clinic;
SELECT * FROM Doctor;
SELECT * FROM Patient;
SELECT * FROM Appointment;

-- =========================
-- PATIENTS DIAGNOSED WITH FATTY LIVER
-- IN THE LAST YEAR
-- =========================

SELECT DISTINCT p.Name
FROM Patient p
JOIN Appointment a ON p.PatientID = a.PatientID
WHERE a.Diagnosis = 'Fatty liver'
AND a.AppointmentDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- =========================
-- ADDRESSES OF CARDIOLOGY CLINICS
-- =========================

SELECT c.Address
FROM Clinic c
JOIN Department d
ON c.DepartmentID = d.DepartmentID
WHERE d.Name = 'Cardiology';

-- =========================
-- TOTAL MONEY PAID BY PATIENT
-- IN LAST 3 YEARS
-- =========================

SELECT SUM(Cost) AS TotalPaid
FROM Appointment
WHERE PatientID = 12527
AND AppointmentDate >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR);

-- =========================
-- VIEW: DOCTOR APPOINTMENTS
-- NEXT MONTH
-- =========================

CREATE VIEW Doctor_Next_Month AS
SELECT DoctorID,
       COUNT(*) AS TotalAppointments
FROM Appointment
WHERE MONTH(AppointmentDate) = MONTH(CURDATE()) + 1
GROUP BY DoctorID;

-- =========================
-- SHOW VIEW DATA
-- =========================

SELECT * FROM Doctor_Next_Month;

-- =========================
-- TOTAL APPOINTMENTS
-- FOR EACH PATIENT
-- =========================

SELECT p.PatientID,
       p.Name,
       COUNT(a.AppointmentID) AS TotalAppointments
FROM Patient p
LEFT JOIN Appointment a
ON p.PatientID = a.PatientID
GROUP BY p.PatientID, p.Name;