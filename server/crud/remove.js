const { server, ExecuteQuery } = require("../config");

const { remove: User } = require("../api/user");

const REMOVE_DATA = [...User];

REMOVE_DATA.forEach(({ uri, query, param, msg }) => {
	server.delete(uri, (req, res) => {
		let paramArr = [];
		param?.forEach((val) => {
			paramArr.push(req?.params[val]);
		});

		ExecuteQuery(
			res,
			query,
			paramArr,
			"delete",
			`${req?.params[msg]} deleted successfully`
		);
	});
});
