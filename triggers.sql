USE ClinicDB;

DROP TRIGGER IF EXISTS check_overlapping_appointments;

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
SHOW TRIGGERS;