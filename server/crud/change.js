const { server, ExecuteQuery } = require("../config");
const { HashPass } = require("../api/auth");

const { change: User } = require("../api/user");

const CHANGE_DATA = [...User];

CHANGE_DATA.forEach(({ uri, query, body, param, msg }) => {
	server.post(uri, (req, res) => {
		let paramArr = [];
		param?.forEach((val) => {
			paramArr.push(req?.params[val]);
		});

		let bodyArr = [];
		body?.forEach((val) => {
			bodyArr.push(req?.body[val]);
		});

		ExecuteQuery(
			res,
			query,
			[...bodyArr, ...paramArr],
			"update",
			`${req?.params[msg]} updated successfully`
		);
	});
});

server.post("/change/user/pass/:id/:name", async (req, res) => {
	const { pass, updated_at } = req?.body;
	const { id, name } = req?.params;
	const hashPassword = await HashPass(pass);

	ExecuteQuery(
		res,
		`UPDATE user SET pass = ?, updated_at = ? WHERE id = ?`,
		[hashPassword, updated_at, id],
		"update",
		`Password for: ${name} updated successfully`
	);
});

