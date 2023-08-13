const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const { DB_PORT } = require("./secret");

const server = express();

// Configure CORS
const whitelist = ["http://localhost:3000", "http://localhost:3001"];

const corsOptionsDelegate = (req, callback) => {
	const corsOptions = {
		origin: whitelist.includes(req?.header("Origin")) ? true : false,
	};
	callback(null, corsOptions);
};

server.use(cors(corsOptionsDelegate));

// Parse incoming requests
server.use(bodyParser.urlencoded({ extended: false }));
server.use(bodyParser.json());

// Authenticate requests with JWT token
// const { VerifyToken } = require("../api/auth");
// server.use(VerifyToken);

// Start the server
server.listen(DB_PORT, () => {
	console.log("Server listening on port: " + DB_PORT);
});

module.exports = Object.freeze({
	server,
});
