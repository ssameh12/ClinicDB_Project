USE ClinicDB;

-- =============================================
-- 1. DEPARTMENT DATA
-- =============================================
INSERT INTO Department (DepartmentID, Name) VALUES 
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Orthopedics'),
(4, 'Dermatology'),
(5, 'Pediatrics'),
(6, 'ENT'),
(7, 'Gastroenterology'),
(8, 'Urology'),
(9, 'Oncology'),
(10, 'Psychiatry');

-- =============================================
-- 2. CLINIC DATA
-- =============================================
INSERT INTO Clinic (ClinicID, Name, Address, DepartmentID) VALUES 
(1, 'Heart Clinic', 'Cairo Street 1', 1),
(2, 'Brain Clinic', 'Cairo Street 2', 2),
(3, 'Bone Clinic', 'Cairo Street 3', 3),
(4, 'Skin Clinic', 'Cairo Street 4', 4),
(5, 'Child Clinic', 'Cairo Street 5', 5),
(6, 'ENT Clinic', 'Cairo Street 6', 6),
(7, 'Digestive Clinic', 'Cairo Street 7', 7),
(8, 'Urology Clinic', 'Cairo Street 8', 8),
(9, 'Cancer Clinic', 'Cairo Street 9', 9),
(10, 'Mental Clinic', 'Cairo Street 10', 10);

-- =============================================
-- 3. DOCTOR DATA
-- =============================================
INSERT INTO Doctor (DoctorID, Name, PhoneNumber, Address, DepartmentID) VALUES 
(1, 'Dr Ahmed', '0101111111', 'Nasr City', 1),
(2, 'Dr Mona', '0101111112', 'Heliopolis', 2),
(3, 'Dr Ali', '0101111113', 'Maadi', 3),
(4, 'Dr Sara', '0101111114', 'Dokki', 4),
(5, 'Dr Omar', '0101111115', '6th October', 5),
(6, 'Dr Nada', '0101111116', 'Giza', 6),
(7, 'Dr Youssef', '0101111117', 'Shubra', 7),
(8, 'Dr Hala', '0101111118', 'Zamalek', 8),
(9, 'Dr Tamer', '0101111119', 'Rehab', 9),
(10, 'Dr Reem', '0101111120', 'Helwan', 10);

-- =============================================
-- 4. PATIENT DATA (Added ID 12527 for your queries)
-- =============================================
INSERT INTO Patient (PatientID, Name, PhoneNumber, Address, BirthDate, Job) VALUES 
(1, 'Ahmed Ali', '0111111111', 'Cairo', '2000-01-01', 'Engineer'),
(2, 'Sara Mohamed', '0111111112', 'Giza', '1999-02-02', 'Teacher'),
(3, 'Omar Hassan', '0111111113', 'Alex', '1998-03-03', 'Student'),
(4, 'Nour Ahmed', '0111111114', 'Cairo', '1997-04-04', 'Doctor'),
(5, 'Mona Ali', '0111111115', 'Giza', '1996-05-05', 'Designer'),
(6, 'Hany Mostafa', '0111111116', 'Fayoum', '1995-06-06', 'Engineer'),
(7, 'Rana Youssef', '0111111117', 'Cairo', '1994-07-07', 'Nurse'),
(8, 'Khaled Tarek', '0111111118', 'Alex', '1993-08-08', 'Lawyer'),
(9, 'Laila Samir', '0111111119', 'Giza', '1992-09-09', 'Accountant'),
(10, 'Youssef Ali', '0111111120', 'Cairo', '1991-10-10', 'Student'),
(12527, 'Shahd Sameh', '0123456789', 'New Cairo', '2004-12-12', 'Software Engineer');

-- =============================================
-- 5. APPOINTMENT DATA (Updated with your ID)
-- =============================================
INSERT INTO Appointment (AppointmentID, AppointmentDate, PatientID, DoctorID, StartTime, EndTime, Cost, Status, Diagnosis) VALUES 
(1, '2026-05-01', 1, 1, '10:00:00', '10:30:00', 500.00, 'scheduled', 'Fatty liver'),
(2, '2026-05-02', 2, 2, '11:00:00', '11:30:00', 400.00, 'scheduled', 'Migraine'),
(3, '2026-05-03', 3, 3, '12:00:00', '12:30:00', 300.00, 'scheduled', 'Fracture'),
(4, '2026-05-04', 4, 4, '13:00:00', '13:30:00', 600.00, 'scheduled', 'Acne'),
(5, '2026-05-05', 5, 5, '14:00:00', '14:30:00', 350.00, 'scheduled', 'Flu'),
(6, '2026-05-06', 6, 6, '15:00:00', '15:30:00', 450.00, 'scheduled', 'Allergy'),
(7, '2026-05-07', 7, 7, '16:00:00', '16:30:00', 700.00, 'scheduled', 'Ulcer'),
(8, '2026-05-08', 8, 8, '17:00:00', '17:30:00', 800.00, 'scheduled', 'Kidney stone'),
(9, '2025-06-10', 12527, 9, '18:00:00', '18:30:00', 1000.00, 'scheduled', 'Regular Checkup'),
(10, '2026-02-15', 12527, 10, '19:00:00', '19:30:00', 1200.00, 'scheduled', 'Follow-up');
