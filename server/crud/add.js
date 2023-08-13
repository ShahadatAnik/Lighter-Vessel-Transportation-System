const { server, ExecuteQuery } = require("../config");
const { HashPass } = require("../api/auth");

const { add: User } = require("../api/user");

const ADD_DATA = [...User];

ADD_DATA.forEach(({ uri, query, body, msg }) => {
	server.post(uri, async (req, res) => {
		let bodyArr = [];
		body?.forEach((val) => {
			bodyArr.push(req?.body[val]);
		});

		await ExecuteQuery(
			res,
			query,
			bodyArr,
			"add",
			`${req?.body[msg]} added successfully`
		);
	});
});

server.post("/add/user", async (req, res) => {
	const { name, email, pass, department, created_at } = req?.body;
	const hashPassword = await HashPass(pass);

	ExecuteQuery(
		res,
		`INSERT INTO user (name, email, pass, department, created_at) VALUES (?, ?, ?, ?, ?)`,
		[name, email, hashPassword, department, created_at],
		"add",
		`${name} added successfully`
	);
});
