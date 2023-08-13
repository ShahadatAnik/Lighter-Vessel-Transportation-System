const { server, ExecuteQuery, db } = require("../config");
const { ComparePass, CreateToken } = require("../api/auth");

const { read: User } = require("../api/user");

const GET_DATA = [...User];

GET_DATA.forEach(({ uri, query, param }) => {
	server.get(uri, (req, res) => {
		if (param === undefined) {
			ExecuteQuery(res, query);
			return;
		}

		let paramArr = [];
		param?.forEach((val) => {
			paramArr.push(req?.params[val]);
		});

		ExecuteQuery(res, query, [...paramArr]);
	});
});

server.post("/get/user/login", (req, res) => {
	const { email, pass } = req?.body;

	db.getConnection((err, connection) => {
		if (err) {
			console.error("Error getting MySQL connection: ", err);
			return res.status(500).json({ error: "Database error" });
		}

		// Call your stored procedure
		connection.query(
			`Select * from user where email = ?`,
			[email],
			async (err, rows) => {
				if (err) {
					console.error("Error getting MySQL connection: ", err);
					return res.status(500).json({ error: "Database error" });
				}

				if (rows?.length === 0) {
					return res.status(200).json({
						status: 200,
						type: "delete",
						message: "User not found",
					});
				}

				if (rows[0].status === 0) {
					return res.status(200).json({
						status: 200,
						type: "delete",
						message: "User is not active",
					});
				}

				await ComparePass(pass, rows[0].pass).then((result) => {
					if (!result) {
						return res.status(200).json({
							status: 200,
							type: "delete",
							message: "Email/Password combination incorrect",
						});
					}

					const token = CreateToken(rows[0]);
					const { id, name, department } = rows[0];

					if (!token.success) {
						return res
							.status(500)
							.json({ error: "Error signing token" });
					}

					return res.status(200).json({
						status: 201,
						type: "create",
						message: "User logged in",
						token: token.token,
						user: { id, name, department },
					});
				});

				connection.release();

				// Don't use the connection here, it has been returned to the pool.
			}
		);
	});
});