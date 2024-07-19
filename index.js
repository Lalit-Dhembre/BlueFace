const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser'); // Require body-parser
const app = express();

// Middleware
app.use(cors()); // Enable CORS for all routes
app.use(bodyParser.json({ limit: '10mb' })); // Set higher limit for JSON payload size

// Import routes
const userRouter = require('./userss'); // Ensure the correct path to your userss.js file
// Define routes
app.use('/userss', userRouter); // Route handling for '/userss'

// Root URL handler
app.get('/', (req, res) => {
    res.send('Welcome to the App Attendance API! Access user routes at /userss.');
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

// Start the server
const PORT = 4000;
app.listen(PORT, () => {
    console.log(`SERVER ON PORT ${PORT}`);
});
