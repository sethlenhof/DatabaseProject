const mysql = require('mysql');

const db = mysql.createConnection({
    host: 'localhost',
    port: '3306',
    user: 'dev',
    password: 'Password1!',
    database: 'event_management_system'
});

db.connect(err => {
    if (err) {
        console.log(err);
    } else {
        console.log('MySQL Connected...');
    }
});

module.exports = db;