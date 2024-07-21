const express = require('express');
const router = express.Router();
const db = require('./db'); // Ensure correct path to db.js

// Promisify db.query if not already done in db.js
const { promisify } = require('util');
db.queryAsync = promisify(db.query).bind(db);

// Route to get all faculty records
router.get('/', async (req, res) => {
  try {
    const rows = await db.queryAsync('SELECT faculty_id, faculty_name, email FROM Faculty');
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Route to handle faculty registration
router.post('/register', async (req, res) => {
  const { faculty_name, email, password, subjects } = req.body;

  const sqlQuery = "INSERT INTO Faculty(faculty_name, email, password, subjects) VALUES (?, ?, ?, ?)";
  

  try {
    await db.queryAsync(sqlQuery, [faculty_name, email, password, subjects]);
    res.status(201).json({ success: true, message: 'Registered successfully' });
  } catch (error) {
    console.error('Error inserting data:', error);
    res.status(500).json({ success: false, message: 'Registration failed' });
  }
});

// Route to handle faculty login
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  const sql = "SELECT * FROM faculty_login WHERE Email = ? AND Password = ?";
  const subjectsSql = "SELECT SUB_ID FROM sem_info WHERE FACULTY_ID = ?";

  try {
    const data = await db.queryAsync(sql, [email, password]);
    if (data.length > 0) {
      const faculty = data[0];
      const subjectsData = await db.queryAsync(subjectsSql, [faculty.FACULTY_ID]);

      // Print the subjectsData to check what is being returned
      console.log('Subjects Data:', subjectsData);

      // Extract subject IDs into a list
      const subjects = subjectsData.map(row => row.SUB_ID);
      faculty.subjects_taught = subjects.join(',');

      // Print the final faculty object before sending it in the response
      console.log('Faculty Object:', faculty);

      res.status(200).json({ success: true, message: 'Login successful', data: faculty });
    } else {
      res.status(401).json({ success: false, message: 'Invalid email or password' });
    }
  } catch (err) {
    console.error('Error during login:', err);
    res.status(500).json({ success: false, message: 'Login failed' });
  }
});





// Route to handle student login
router.post('/loginstudent', async (req, res) => {
  const { email, password } = req.body;
  const sql = "SELECT * FROM student_info WHERE EMAIL = ? AND PASSWORD = ?";
  const subjectsSql = "SELECT SUB_ID FROM sem_info WHERE SEMESTER = ? AND BRANCH = ? AND DIVISION = ? AND (BATCH = ? OR BATCH = 'ALL')";

  try {
    const data = await db.queryAsync(sql, [email, password]);
    if (data.length > 0) {
      const student = data[0];
      console.log('Student Data:', student);

      const subjectsQueryParams = [student.SEMESTER, student.BRANCH, student.DIVISION, student.BATCH];
      console.log('Subjects Query Parameters:', subjectsQueryParams);

      const subjectsData = await db.queryAsync(subjectsSql, subjectsQueryParams);
      console.log('Subjects Data:', subjectsData);

      const subjects = subjectsData.map(row => row.SUB_ID);
      student.subjects_taught = subjects.join(',');
      console.log('Student Object:', student);
      res.status(200).json({ success: true, message: 'Login successful', data: student });
    } else {
      res.status(401).json({ success: false, message: 'Invalid email or password' });
    }
  } catch (err) {
    console.error('Error during student login:', err);
    res.status(500).json({ success: false, message: 'Login failed' });
  }
});



// Route to handle attendance recording
router.post('/takeAttendance', async (req, res) => {
  const { division, semester, branch, PRN, Subject_id, Batch } = req.body;

  const queryFetchSemId = "SELECT SEM_ID FROM sem_info WHERE SEMESTER = ? AND BRANCH = ? AND DIVISION = ? AND SUB_ID = ? AND (BATCH = ? OR BATCH = 'ALL')";
  const insertAttendance = 'INSERT INTO tempattendance (SEM_ID, PRN, BATCH, SEMESTER, BRANCH, DIVISION) VALUES (?, ?, ?, ?, ?, ?)';

  console.log('Request Body:', req.body);

  try {
    // Fetch SEM_ID from sem_info table
    const rows = await db.queryAsync(queryFetchSemId, [semester, branch, division, Subject_id, Batch]);

    console.log('Query Result:', rows); // Log the raw query result

    // Check if rows is defined and contains results
    if (rows.length > 0) {
      const sem_id = rows[0].SEM_ID;
      console.log('SEM_ID:', sem_id,);

      // Insert SEM_ID and PRN into tempattendance table
      await db.queryAsync(insertAttendance, [sem_id, PRN, Batch, semester, branch, division]);

      res.status(200).send('Attendance recorded successfully');
    } else {
      res.status(404).send('SEM_ID not found');
    }
  } catch (err) {
    console.error('Error inserting data:', err);
    res.status(500).send('Failed to record attendance');
  }
});





// Route to handle attendance commit
router.post('/attendance/commit', async (req, res) => {
  const { tableName, localDateTime, attendanceData } = req.body;
  console.log(tableName);

  const dateObj = new Date(localDateTime);
  const [year, month, day] = localDateTime.split('-');
  const monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  const monthName = monthNames[parseInt(month, 10) - 1];

  
  try {
    // Properly sanitize and escape table and column names
    const sanitizedTableName = tableName;
    const sanitizedColumnName = `${parseInt(day, 10)} ${monthName} ${year}`;
    console.log(localDateTime);
    console.log(sanitizedTableName);
    
    // Check if the column exists
    const checkColumnQuery = "SELECT COUNT(*) AS count FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = ? AND column_name = ?"

    const [result] = await db.queryAsync(checkColumnQuery,[sanitizedTableName,sanitizedColumnName]);

    if (result.count === 0) {
      // Column doesn't exist, so add it
      const alterQuery = `ALTER TABLE \`${sanitizedTableName}\` ADD COLUMN \`${sanitizedColumnName}\` VARCHAR(10) DEFAULT 'Absent'`;
await db.queryAsync(alterQuery);

    }

    // Update attendance status
    for (const student of attendanceData) {
      const updateQuery = `UPDATE \`${sanitizedTableName}\` SET \`${sanitizedColumnName}\` = ? WHERE PRN = ?`;
await db.queryAsync(updateQuery, [student.status, student.PRN]);

    }

    res.status(200).json({ success: true, message: 'Attendance committed successfully' });
  } catch (err) {
    console.error('Error committing attendance data:', err);
    res.status(500).json({ success: false, message: 'Failed to commit attendance data' });
  }
});

// Route to get students based on semester and branch
router.get('/studentlist', async (req, res) => {
  const { semester, branch, division, batch, faculty_id } = req.query;
  console.log('Query Parameters:', req.query); // Log the received parameters

  if (!semester || !branch || !division || !batch || !faculty_id) {
    console.log('Missing query parameters:', req.query);
    return res.status(400).json({
      success: false,
      message: 'Missing query parameters',
    });
  }

  // Define the SQL queries
  const queryFetchSemId = `
    SELECT SEM_ID 
    FROM sem_info 
    WHERE SEMESTER = ? 
      AND BRANCH = ? 
      AND DIVISION = ? 
      AND BATCH = ?
      AND FACULTY_ID = ?`;

  const queryFetchStudentInfo = batch === 'ALL'
    ? `
      SELECT PRN, Name 
      FROM student_info 
      WHERE BRANCH = ? AND DIVISION = ? AND SEMESTER = ?
    `
    : `
      SELECT PRN, Name 
      FROM student_info 
      WHERE BRANCH = ? AND DIVISION = ? AND BATCH = ? AND SEMESTER = ?
    `;

  const queryFetchPrns = `
    SELECT PRN 
    FROM tempattendance 
    WHERE SEM_ID = ?
  `;

  try {
    // Fetch student details from student_info table
    const studentInfoRows = await db.queryAsync(queryFetchStudentInfo, 
      batch === 'ALL' 
        ? [branch, division, semester] 
        : [branch, division, batch, semester]
    );
    console.log('Student Info Rows:', JSON.stringify(studentInfoRows));

    if (studentInfoRows.length === 0) {
      console.log('No students found for the given parameters:', { branch, division, batch, semester });
      return res.status(404).json({
        success: false,
        message: 'No students found for the given parameters',
      });
    }

    // Extract PRNs from studentInfoRows
    const prns = studentInfoRows.map(student => student.PRN);
    console.log('Extracted PRNs from student info:', prns);

    // Fetch SEM_ID from sem_info table
    const semIdRows = await db.queryAsync(queryFetchSemId, [semester, branch, division, batch, faculty_id]);
    console.log('SEM ID ROWS:', JSON.stringify(semIdRows));

    if (semIdRows.length > 0) {
      const semId = semIdRows[0].SEM_ID;
      console.log('SEM ID:', semId);

      // Fetch PRNs from tempattendance table
      const prnRows = await db.queryAsync(queryFetchPrns, [semId]);
      console.log('PRN ROWS:', JSON.stringify(prnRows));

      // Extract PRNs from tempattendance
      const presentPrns = prnRows.map(row => row.PRN);
      console.log('Extracted PRNs from tempattendance:', presentPrns);

      // Process student data to include isPresent field
      const studentList = studentInfoRows.map(student => {
        return {
          PRN: student.PRN,
          Name: student.Name,
          isPresent: presentPrns.includes(student.PRN) // Check if PRN is in tempattendance
        };
      });

      res.status(200).json({
        success: true,
        students: studentList,
      });
    } else {
      console.log('No SEM_ID found for the given parameters:', { semester, branch, division, batch, faculty_id });
      res.status(404).json({
        success: false,
        message: 'No SEM_ID found for the given parameters',
      });
    }
  } catch (error) {
    console.error('Error fetching student list:', error);
    res.status(500).send('Error fetching student list');
  }
});


module.exports = router;

