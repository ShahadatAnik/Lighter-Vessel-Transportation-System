require("dotenv").config();

// process.env
const { DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_PORT, PRIVATE_KEY, SALT } =
	process.env;

module.exports = Object.freeze({
	DB_HOST,
	DB_USER,
	DB_PASS,
	DB_NAME,
	DB_PORT,
	PRIVATE_KEY,
	SALT,
});
