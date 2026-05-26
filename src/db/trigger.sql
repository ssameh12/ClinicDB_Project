-- Trigger that prevents overlapping appointments for the same doctor on the same date.
-- This file contains a single CREATE TRIGGER statement (no DELIMITER directives)
-- so it can be sent to MySQL as one statement by the Node setup script.

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
END
