USE ClinicDB;

DROP VIEW IF EXISTS Doctor_Next_Month;

CREATE VIEW Doctor_Next_Month AS
SELECT DoctorID, COUNT(*) AS TotalAppointments
FROM Appointment
WHERE MONTH(AppointmentDate) = MONTH(CURDATE() + INTERVAL 1 MONTH)
  AND YEAR(AppointmentDate) = YEAR(CURDATE() + INTERVAL 1 MONTH)
GROUP BY DoctorID;
SELECT * FROM Doctor_Next_Month;