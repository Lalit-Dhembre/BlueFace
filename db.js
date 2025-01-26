var mysql = require('mysql');
var connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'lalit123xandy',
    port: '3306',
    database: 'newdatabase'
});

connection.connect(function(err) {
    if (err) {
        console.error('Database connection failed:', err.stack);
        return;
    }
    console.log('Connected to database.');
});

module.exports = connection;
