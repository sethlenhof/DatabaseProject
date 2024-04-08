const express = require('express');
const port = 2623;
const app = express();

app.use(express.json());

const db = require('./database');
const { ok } = require('assert');

app.listen(port, () => {
	console.log(`Express server listening at http://localhost:${port}`);
});

app.get("/", (req, res) => {
    res.send('API is working!');
});

app.get("/showTables", (req, res) => {
    db.query('SHOW TABLES;', (err, results) => {
        if (err) {
            res.status
        }
        res.status(200).send(results);
    });
});