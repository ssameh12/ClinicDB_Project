USE ClinicDB;

CREATE VIEW Doctor_Next_Month AS
SELECT DoctorID, COUNT(*) AS TotalAppointments
FROM Appointment
WHERE MONTH(AppointmentDate) = MONTH(CURDATE()) + 1
GROUP BY DoctorID;

