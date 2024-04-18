const express = require('express');
const port = 2363;
const app = express();

app.use(express.json());

const db = require('./database');
const { ok } = require('assert');

app.listen(port, () => {
	console.log(`Express server listening at http://localhost:${port}`);
});

app.get("/api", (req, res) => {
    res.send('API is working!');
});

app.get("/api/showTables", (req, res) => {
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

// *===========================================================*
// |                	CREATE EVENT API           			   |
// *===========================================================*
// Incoming: { rsoId, universityId, name, category, description, startTime, endTime, location, contactPhone, contactEmail }
// Outgoing: { status }
// example api call: http://localhost:2363/api/events/create with body: (1, 1, 'UCF Event', 'private', 'This is a test event', '2021-10-01 12:00:00', '2021-10-01 14:00:00', 'UCF Student Union', '407-123-4567', 'test@email.com');
/* Body:
{
	"rsoId": 1,
	"universityId": 1,
	"name": "UCF Event",
	"category": "private",
	"description": "This is a test event",
	"startTime": "2021-10-01 12:00:00",
	"endTime": "2021-10-01 14:00:00",
	"location": "UCF Student Union",
	"contactPhone": "407-123-4567",
	"contactEmail": "test@email.com"
}
*/
app.post("/api/events/create", (req, res) => {
	// create const based on incoming
	const { rsoId, universityId, name, category, description, startTime, endTime, location, contactPhone, contactEmail } = req.body;
	if ( !name || !category || !description || !startTime || !endTime || !location || !contactPhone || !contactEmail) {
		return res.status(400).json({ error: "missingFields" });
	}


	// Assuming 'sanitizeData' function is defined elsewhere to sanitize inputs
	var data = sanitizeData({ rsoId, universityId, name, category, description, startTime, endTime, location, contactPhone, contactEmail });
	
	//startTime and endTime need to be formatted YYYY-MM-DDT12:00:00 -> 2024-04-10T12:00:00


	const sql = "CALL insert_event(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	const params = [data.rsoId, data.universityId, data.name, data.category, data.description, data.startTime, data.endTime, data.location, data.contactPhone, data.contactEmail];
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
		return res.status(200).json({Success: "Successfully created event"});
	});
});

// *===========================================================*
// |                	GET EVENTS API           			   |
// *===========================================================*
// Incoming: { userId }
// Outgoing: { status, events }

app.get("/api/users/events", (req, res) => {
	const { userId } = req.query;

	if (!userId) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ userId });

	const sql = "CALL find_all_events(?)";
	const params = [data.userId];
	db.query(sql, params, function (err, results) {
		// Handle SQL error
		if (err) {
			return res.status(400).json({ error: "sqlError" });
		}

		const response = results[0];

		if (response.RESPONSE_STATUS === "Error") {
			return res.status(400).json({ error: response.RESPONSE_MESSAGE });
		}
		return res.status(200).json({ events: response });
	});
});

// *===========================================================*
// |                	GET EVENT API           			   |
// *===========================================================*
// Incoming: { eventId }
// Outgoing: { status, event }
app.get("/api/events/eventDetail", (req, res) => {
	const { eventId } = req.query;
	if (!eventId) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ eventId });

	const sql = "CALL find_event_by_id(?)";
	const params = [data.eventId];
	db.query(sql, params, function (err, results) {
		// Handle SQL error
		if (err) {
			return res.status(400).json({ error: "sqlError" });
		}

		const response = results[0][0];

		if (response.RESPONSE_STATUS === "Error") {
			return res.status(400).json({ error: response.RESPONSE_MESSAGE });
		}
		return res.status(200).json({ event: response });
	});
});

// *===========================================================*
// |                	CREATE COMMENT API         			   |
// *===========================================================*
// Incoming: { userId, eventId, comment, rating }
// Outgoing: { status }
app.post("/api/events/comments/create", (req, res) => {
	const { userId, eventId, comment, rating } = req.body;
	if (!userId || !eventId || !comment || !rating) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ userId, eventId, comment, rating });

	const sql = "CALL insert_comment(?, ?, ?, ?)";
	const params = [data.userId, data.eventId, data.comment, data.rating];
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


// *===========================================================*
// |                	GET COMMENTS FOR EVENT         		   |
// *===========================================================*
// Incoming: { eventId }
// Outgoing: { status, comments }
app.get("/api/events/comments", (req, res) => {
	const { eventId } = req.query;
	if (!eventId) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ eventId });

	const sql = "CALL get_comments_for_event(?)";
	const params = [data.eventId];
	db.query(sql, params, function (err, results) {
		// Handle SQL error
		if (err) {
			return res.status(400).json({ error: "sqlError" });
		}

		const response = results[0];

		if (response.RESPONSE_STATUS === "Error") {
			return res.status(400).json({ error: response.RESPONSE_MESSAGE });
		}
		return res.status(200).json({ comments: response });
	});
});

// *===========================================================*
// |                	GET RSO ADMIN MEMBERSHIP API     	   |
// *===========================================================*
//Incoming: { userId }
//Outgoing: { status, data }
app.post("/api/rso/admin", (req, res) => {
	const { userId } = req.body;
	if (!userId) {
		return res.status(400).json({ error: "missingFields" });
	}

	// Assuming 'sanitizeData' function is defined elsewhere to sanitize inputs
	var data = sanitizeData({ userId });

	const sql = "CALL get_rso_admin_membership(?)";
	const params = [data.userId];
	db.query(sql, params, function (err, result) {
		// Handle SQL error
		if (err) {
			return res.status(400).json({ error: "sqlError" });
		}

		//extract the response from the stored procedure
		const response = result[0];

		if (response.RESPONSE_STATUS === "Error") {
			return res.status(400).json({ error: response.RESPONSE_MESSAGE });
		}
		return res.status(200).json(response);
	});
});


// *===========================================================*
// |                 USER TYPE API                             |
// *===========================================================*
// Incoming: { userId }
// Outgoing: { status, userType }
app.get("/api/users/type", (req, res) => {
    const { userId } = req.query; // Assuming the userId is passed as a query parameter

    if (!userId) {
        return res.status(400).json({ error: "Missing Fields" });
    }
	var data = sanitizeData({ userId });
    const sql = "CALL get_user_type(?)";
    const params = [data.userId];
    db.query(sql, params, function (err, results) {
        if (err) {
            return res.status(400).json({ error: "SQL error", details: err.message });
        }
        
        const response = results[0][0]; // Assuming that the stored procedure returns the result in the first index
        if (response) {
			console.log(response);
            return res.status(200).json({
                userType: response.RESPONSE_MESSAGE
            });
        } else {
            return res.status(404).json({ error: "User not found" });
        }
    });
});

// *===========================================================*
// |               UPDATE UNIVERSIY INFO API       			   |
// *===========================================================*
// Incoming: { userId }
// Outgoing: { status }
app.post("/api/updateUniversityInfo", (req, res) => {
	const { userId, name, location, description, numStudents, color } = req.body;
	if (!userId || !name || !location || !description || !numStudents || !color) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ userId, name, location, description, numStudents, color });

	const sql = "CALL update_university_info(?, ?, ?, ?, ?, ?)";
	const params = [data.userId, data.name, data.location, data.description, data.numStudents, data.color];
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
		return res.status(200).json({response: response.RESPONSE_MESSAGE});
	});
});


// *===========================================================*
// |               		CREATE RSO API		       			   |
// *===========================================================*
// Incoming: { userId, name, type, color, description }
// Outgoing: { status }
app.post("/api/rsos/create", (req, res) => {
	const { userId, name, type, color, description } = req.body;
	if (!userId || !name || !type || !color || !description) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ userId, name, type, color, description });

	const sql = "CALL create_rso_and_admin(?, ?, ?, ?, ?)";
	db.query(sql, [data.userId, data.name, data.type, data.color, data.description], function (err, result) {
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

// *===========================================================*
// |               		GET RSOs API       			           |
// *===========================================================*
// Incoming: { userId }
// Outgoing: { status, rsos }
app.get("/api/rsos", (req, res) => {
	const { userId } = req.query;
	if (!userId) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ userId });

	const sql = "CALL get_rsos(?)";
	const params = [data.userId];
	db.query(sql, params, function (err, results) {
		// Handle SQL error
		if (err) {
			return res.status(400).json({ error: "sqlError" });
		}

		const response = results[0];

		if (response.RESPONSE_STATUS === "Error") {
			return res.status(400).json({ error: response.RESPONSE_MESSAGE });
		}
		return res.status(200).json({ rsos: response });
	});
});

// *===========================================================*
// |               		JOIN RSO API       			           |
// *===========================================================*
// Incoming: { userId, rsoId }
// Outgoing: { status }
app.post("/api/rso/join", (req, res) => {
	const { userId, rsoId } = req.body;
	if (!userId || !rsoId) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ userId, rsoId });

	const sql = "CALL join_rso(?, ?)";
	const params = [data.userId, data.rsoId];
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

// *===========================================================*
// |             GET UNNAPROVED EVENTS API     			       |
// *===========================================================*
// Incoming: { userId }
// Outgoing: { status, events }
app.get("/api/events/unapproved", (req, res) => {
	const { userId } = req.query;
	if (!userId) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ userId });

	const sql = "CALL get_unapproved_events(?)";
	const params = [data.userId];
	db.query(sql, params, function (err, results) {
		// Handle SQL error
		if (err) {
			return res.status(400).json({ error: "sqlError" });
		}

		const response = results[0];

		if (response.RESPONSE_STATUS === "Error") {
			return res.status(400).json({ error: response.RESPONSE_MESSAGE });
		}
		return res.status(200).json({ events: response });
	});
});

// *===========================================================*
// |             APPROVE EVENT API     			               |
// *===========================================================*
// Incoming: { userId, eventId }
// Outgoing: { status }
app.post("/api/events/approve", (req, res) => {
	const { userId, eventId } = req.body;
	if (!userId || !eventId) {
		return res.status(400).json({ error: "missingFields" });
	}

	var data = sanitizeData({ userId, eventId });

	const sql = "CALL approve_event(?, ?)";
	const params = [data.userId, data.eventId];
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
