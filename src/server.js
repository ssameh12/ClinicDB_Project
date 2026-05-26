require('dotenv').config();

const path = require('path');
const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');

const app = express();
const PORT = Number(process.env.PORT || 3001);

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'ClinicDB',
  waitForConnections: true,
  connectionLimit: 10,
  namedPlaceholders: true,
  dateStrings: true
});

function normalizeTime(value) {
  if (!value) return value;
  return value.length === 5 ? `${value}:00` : value;
}

function sendError(res, error, status = 500) {
  const message = error?.sqlMessage || error?.message || 'Server error';
  res.status(status).json({ error: message });
}

async function fetchAppointments(where = '', params = {}) {
  const [rows] = await pool.execute(`
    SELECT
      a.AppointmentID,
      a.AppointmentDate,
      a.PatientID,
      p.Name AS PatientName,
      a.DoctorID,
      d.Name AS DoctorName,
      dep.Name AS Department,
      a.StartTime,
      a.EndTime,
      a.Cost,
      a.Status,
      a.Diagnosis
    FROM Appointment a
    JOIN Patient p ON p.PatientID = a.PatientID
    JOIN Doctor d ON d.DoctorID = a.DoctorID
    LEFT JOIN Department dep ON dep.DepartmentID = d.DepartmentID
    ${where}
    ORDER BY a.AppointmentDate DESC, a.StartTime DESC, a.AppointmentID DESC
  `, params);
  return rows;
}

async function hasOverlap({ AppointmentID, AppointmentDate, DoctorID, StartTime, EndTime }) {
  const [rows] = await pool.execute(`
    SELECT AppointmentID, StartTime, EndTime
    FROM Appointment
    WHERE DoctorID = ?
      AND AppointmentDate = ?
      AND (? IS NULL OR AppointmentID <> ?)
      AND ? < EndTime
      AND ? > StartTime
    LIMIT 1
  `, [DoctorID, AppointmentDate, AppointmentID || null, AppointmentID || null, normalizeTime(StartTime), normalizeTime(EndTime)]);
  return rows[0] || null;
}

app.get('/api/health', async (req, res) => {
  try {
    await pool.query('SELECT 1 AS ok');
    res.json({ ok: true });
  } catch (error) {
    sendError(res, error, 503);
  }
});

app.get('/api/stats', async (req, res) => {
  try {
    const [[departments]] = await pool.query('SELECT COUNT(*) AS count FROM Department');
    const [[doctors]] = await pool.query('SELECT COUNT(*) AS count FROM Doctor');
    const [[patients]] = await pool.query('SELECT COUNT(*) AS count FROM Patient');
    const [[appointments]] = await pool.query('SELECT COUNT(*) AS count FROM Appointment');
    res.json({
      departments: departments.count,
      doctors: doctors.count,
      patients: patients.count,
      appointments: appointments.count
    });
  } catch (error) {
    sendError(res, error);
  }
});

app.get('/api/departments', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT d.DepartmentID, d.Name,
        COUNT(DISTINCT c.ClinicID) AS ClinicCount,
        COUNT(DISTINCT doc.DoctorID) AS DoctorCount
      FROM Department d
      LEFT JOIN Clinic c ON c.DepartmentID = d.DepartmentID
      LEFT JOIN Doctor doc ON doc.DepartmentID = d.DepartmentID
      GROUP BY d.DepartmentID, d.Name
      ORDER BY d.DepartmentID
    `);
    res.json(rows);
  } catch (error) {
    sendError(res, error);
  }
});

app.get('/api/clinics', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT c.ClinicID, c.Name, c.Address, c.DepartmentID, d.Name AS Department
      FROM Clinic c
      LEFT JOIN Department d ON d.DepartmentID = c.DepartmentID
      ORDER BY c.ClinicID
    `);
    res.json(rows);
  } catch (error) {
    sendError(res, error);
  }
});

app.get('/api/doctors', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT doc.DoctorID, doc.Name, doc.PhoneNumber, doc.Address, doc.DepartmentID, d.Name AS Department
      FROM Doctor doc
      LEFT JOIN Department d ON d.DepartmentID = doc.DepartmentID
      ORDER BY doc.DoctorID
    `);
    res.json(rows);
  } catch (error) {
    sendError(res, error);
  }
});

app.get('/api/patients', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Patient ORDER BY PatientID');
    res.json(rows);
  } catch (error) {
    sendError(res, error);
  }
});

app.get('/api/appointments', async (req, res) => {
  try {
    res.json(await fetchAppointments());
  } catch (error) {
    sendError(res, error);
  }
});

app.post('/api/appointments', async (req, res) => {
  const b = req.body || {};
  const required = ['AppointmentID', 'AppointmentDate', 'PatientID', 'DoctorID', 'StartTime', 'EndTime', 'Cost', 'Status', 'Diagnosis'];
  const missing = required.filter(k => b[k] === undefined || b[k] === null || String(b[k]).trim() === '');
  if (missing.length) return res.status(400).json({ error: `Missing field(s): ${missing.join(', ')}` });

  if (normalizeTime(b.EndTime) <= normalizeTime(b.StartTime)) {
    return res.status(400).json({ error: 'EndTime must be after StartTime' });
  }

  try {
    const overlap = await hasOverlap(b);
    if (overlap) {
      return res.status(409).json({ error: `Doctor has overlapping appointment (#${overlap.AppointmentID}, ${overlap.StartTime}-${overlap.EndTime})` });
    }

    await pool.execute(`
      INSERT INTO Appointment
        (AppointmentID, AppointmentDate, PatientID, DoctorID, StartTime, EndTime, Cost, Status, Diagnosis)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      Number(b.AppointmentID),
      b.AppointmentDate,
      Number(b.PatientID),
      Number(b.DoctorID),
      normalizeTime(b.StartTime),
      normalizeTime(b.EndTime),
      Number(b.Cost),
      b.Status,
      b.Diagnosis
    ]);
    const rows = await fetchAppointments('WHERE a.AppointmentID = ?', [Number(b.AppointmentID)]);
    res.status(201).json(rows[0]);
  } catch (error) {
    sendError(res, error, error?.code === 'ER_DUP_ENTRY' ? 409 : 500);
  }
});

app.patch('/api/appointments/:id/status', async (req, res) => {
  const { id } = req.params;
  const { status } = req.body || {};
  const allowed = ['scheduled', 'completed', 'cancelled', 'in progress', 'postponed'];
  if (!allowed.includes(String(status || '').toLowerCase())) {
    return res.status(400).json({ error: `Status must be one of: ${allowed.join(', ')}` });
  }
  try {
    const [result] = await pool.execute('UPDATE Appointment SET Status = ? WHERE AppointmentID = ?', [status, id]);
    if (!result.affectedRows) return res.status(404).json({ error: 'Appointment not found' });
    res.json({ ok: true });
  } catch (error) {
    sendError(res, error);
  }
});

app.delete('/api/appointments/:id', async (req, res) => {
  try {
    const [result] = await pool.execute('DELETE FROM Appointment WHERE AppointmentID = ?', [req.params.id]);
    if (!result.affectedRows) return res.status(404).json({ error: 'Appointment not found' });
    res.json({ ok: true });
  } catch (error) {
    sendError(res, error);
  }
});

app.post('/api/ai/validate-booking', async (req, res) => {
  const { booking } = req.body || {};
  if (!booking) return res.status(400).json({ error: 'booking is required' });
  if (normalizeTime(booking.EndTime) <= normalizeTime(booking.StartTime)) {
    return res.json({ ok: false, message: '✗ End time must be after start time.' });
  }
  try {
    const overlap = await hasOverlap(booking);
    if (overlap) {
      return res.json({
        ok: false,
        message: `✗ Doctor is not available. Overlap with appointment #${overlap.AppointmentID} (${overlap.StartTime}-${overlap.EndTime}).`
      });
    }
    res.json({ ok: true, message: '✓ Appointment looks valid. No doctor overlap was found.' });
  } catch (error) {
    sendError(res, error);
  }
});

function generateSql(question) {
  const q = String(question || '').toLowerCase();
  if (q.includes('doctor') && (q.includes('most') || q.includes('highest')) && q.includes('appointment')) {
    return {
      sql: `SELECT d.DoctorID, d.Name, COUNT(a.AppointmentID) AS TotalAppointments
FROM Doctor d
LEFT JOIN Appointment a ON a.DoctorID = d.DoctorID
GROUP BY d.DoctorID, d.Name
ORDER BY TotalAppointments DESC
LIMIT 1;`,
      explanation: 'Counts appointments per doctor and returns the doctor with the highest count.'
    };
  }
  if (q.includes('revenue') || q.includes('total paid') || q.includes('cost')) {
    return {
      sql: `SELECT dep.Name AS Department, SUM(a.Cost) AS TotalRevenue
FROM Appointment a
JOIN Doctor d ON d.DoctorID = a.DoctorID
JOIN Department dep ON dep.DepartmentID = d.DepartmentID
GROUP BY dep.Name
ORDER BY TotalRevenue DESC;`,
      explanation: 'Sums appointment cost by the doctor department.'
    };
  }
  const diagnosisMatch = q.match(/diagnosed with ([a-zA-Z ]+)/);
  if (diagnosisMatch) {
    const diagnosis = diagnosisMatch[1].trim().replace(/'/g, "''");
    return {
      sql: `SELECT DISTINCT p.PatientID, p.Name, p.PhoneNumber, a.Diagnosis
FROM Patient p
JOIN Appointment a ON a.PatientID = p.PatientID
WHERE LOWER(a.Diagnosis) = LOWER('${diagnosis}');`,
      explanation: `Lists patients whose appointment diagnosis is ${diagnosis}.`
    };
  }
  if (q.includes('clinic')) {
    return {
      sql: `SELECT c.ClinicID, c.Name, c.Address, d.Name AS Department
FROM Clinic c
LEFT JOIN Department d ON d.DepartmentID = c.DepartmentID
ORDER BY c.ClinicID;`,
      explanation: 'Lists clinics with their department.'
    };
  }
  if (q.includes('department')) {
    return {
      sql: `SELECT d.DepartmentID, d.Name,
  COUNT(DISTINCT c.ClinicID) AS ClinicCount,
  COUNT(DISTINCT doc.DoctorID) AS DoctorCount
FROM Department d
LEFT JOIN Clinic c ON c.DepartmentID = d.DepartmentID
LEFT JOIN Doctor doc ON doc.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.Name
ORDER BY d.DepartmentID;`,
      explanation: 'Lists departments with clinic and doctor counts.'
    };
  }
  if (q.includes('patient')) {
    return { sql: 'SELECT * FROM Patient ORDER BY PatientID;', explanation: 'Lists all patients.' };
  }
  if (q.includes('doctor')) {
    return {
      sql: `SELECT doc.DoctorID, doc.Name, doc.PhoneNumber, doc.Address, d.Name AS Department
FROM Doctor doc
LEFT JOIN Department d ON d.DepartmentID = doc.DepartmentID
ORDER BY doc.DoctorID;`,
      explanation: 'Lists all doctors with their department.'
    };
  }
  return {
    sql: `SELECT a.AppointmentID, a.AppointmentDate, p.Name AS PatientName, d.Name AS DoctorName,
  a.StartTime, a.EndTime, a.Cost, a.Status, a.Diagnosis
FROM Appointment a
JOIN Patient p ON p.PatientID = a.PatientID
JOIN Doctor d ON d.DoctorID = a.DoctorID
ORDER BY a.AppointmentDate DESC, a.StartTime DESC;`,
    explanation: 'Default query: lists all appointments with patient and doctor names.'
  };
}

app.post('/api/ai/query', (req, res) => {
  res.json(generateSql(req.body?.question));
});

app.post('/api/query/run', async (req, res) => {
  const sql = String(req.body?.sql || '').trim();
  if (!sql.toLowerCase().startsWith('select')) return res.status(400).json({ error: 'Only SELECT queries are allowed from the UI.' });
  if (/;\s*\S/.test(sql)) return res.status(400).json({ error: 'Only one SQL statement is allowed.' });
  try {
    const [rows] = await pool.query(sql);
    res.json({ rows });
  } catch (error) {
    sendError(res, error, 400);
  }
});

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Clinic app running on http://localhost:${PORT}`);
});
