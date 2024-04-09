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

//test api to get all users
//make a get request to http://localhost:2363/users/add
// *===========================================================*
// |                Get All Users API			               |
// *===========================================================*
// Incoming: {  }
// Outgoing: { status }
app.get("/api/users", (req, res) => {

    // UPDATE USER_LOGIN WITH WHATEVER THE TABLE NAME IS
	db.query("SELECT * FROM USER_LOGIN", (err, rows) => {
		if (err) {
			res.status(400).json({ error: err.message });
			return;
		}
		res.json({
			message: "success",
			data: rows,
		});
	});
});

// *===========================================================*
// |                	Login API            			       |
// *===========================================================*
// Incoming: { email, password }
// Outgoing: { status, token }
app.post("/api/login", (req, res) => {
	const { email, password } = req.body;
	if (!email || !password) {
		return res.status(400).send("Missing fields");
	}
	var data = sanitizeData({ email, password });
	const sql = "CALL validate_user(?, ?)";
	const params = [data.email, data.password];
	db.query(sql, params, (err, results, fields) => {
		if (err) {
			// Handle SQL error
			return res.status(400).json({ error: "sqlError" });
		}

		const response = results[0][0];

		if (response.RESPONSE_STATUS === "Error") {
			return res.status(400).json({ error: response.RESPONSE_MESSAGE });
		} else {
			// User is valid, get token from database
			console.log("VALID LOGIN");
			return res.status(200).json(response.RESPONSE_MESSAGE);
		}
	});
});


// *===========================================================*
// |                	USER SIGNUP API            			   |
// *===========================================================*
// Incoming: { email, password }
// Outgoing: { status }
app.post("/api/users/signup", (req, res) => {
	const { email, password } = req.body;
	if (!email || !password) {
		return res.status(400).json({ error: "missingFields" });
	}

	// Assuming 'sanitizeData' function is defined elsewhere to sanitize inputs
	var data = sanitizeData({ email, password });

	const sql = "CALL insert_user_login(?, ?)";
	const params = [data.email, data.password];
	db.query(sql, params, function (err, result) {
		// Handle SQL error
		if (err) {
			return res.status(400).json({ error: "sqlError" });
		}

		//extract the response from the stored procedure
		const response = result[0][0];

		if (response.RESPONSE_STATUS === "Error") {
			return res.status(400).json({ error: response.RESPONSE_MESSAGE });
		}
		return res.status(200).json({});
	});
});


// sanitizeData function to sanitize input data
// prevent SQL injection
function sanitizeData(data) {
	if (typeof data === "string") {
		// String sanitization
		return data
			.replace(/&/g, "&amp;")
			.replace(/</g, "&lt;")
			.replace(/>/g, "&gt;")
			.replace(/"/g, "&quot;")
			.replace(/'/g, "&#039;")
			.replace(/'/g, "''"); // SQL Injection basic protection
	} else if (Array.isArray(data)) {
		// If it's an array, sanitize each element
		return data.map((item) => sanitizeData(item));
	} else if (typeof data === "object" && data !== null) {
		// If it's an object, sanitize each property
		const sanitizedObject = {};
		for (const key in data) {
			sanitizedObject[key] = sanitizeData(data[key]);
		}
		return sanitizedObject;
	}
	// Return data as is if it's not a string, array, or object
	return data;
}
