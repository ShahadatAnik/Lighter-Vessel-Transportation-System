// Create
// crud - add.js

// Read
const read = [
	{
		uri: "/get/user",
		query: `SELECT id, name, email, department, created_at, updated_at, status from user`,
	},
	{
		uri: "/get/user/:id",
		query: `SELECT id, name, email, department, created_at, updated_at, status from user WHERE id = ?`,
		param: ["id"],
	},
	// /get/user/login - crud - read.js
];

// Update
const change = [
	{
		uri: "/change/user/:id/:name",
		query: `UPDATE user SET name = ?, email = ?, department = ?, updated_at = ? WHERE id = ?`,
		body: ["name", "email", "department", "updated_at"],
		param: ["id"],
		msg: "name", // from param
	},
	{
		uri: "/change/user/status/:id/:status/:updated_at/:name",
		query: `UPDATE user SET status = ?, updated_at = ? WHERE id = ?`,
		param: ["status", "updated_at", "id"],
		msg: "name", // from param
	},
	// /change/user/pass/:id/:name - crud - change.js
];

// Delete
const remove = [
	{
		uri: "/delete/user/:id/:name",
		query: `DELETE FROM user WHERE id = ?`,
		param: ["id"],
		msg: "name",
	},
];

// Export modules
module.exports = Object.freeze({
	read,
	change,
	remove,
});
