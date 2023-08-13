const { db } = require("./db.js");
const { server } = require("./server.js");

const SendResponse = async (res, operation, results = [], msg = "") => {
	const response = {
		add: {
			status: 201,
			type: "create",
			message: msg,
			id: results?.insertId,
		},
		update: { status: 200, type: "update", message: msg },
		delete: { status: 200, type: "delete", message: msg },
		NO_RESULTS: {
			status: 404,
			type: "error",
			message: "No results found",
		},
		ER_ENTRY: {
			status: 500,
			type: "error",
			message: "Error executing the query",
		},
		ER_CONNECTION: {
			status: 500,
			type: "error",
			message: "Error connecting to the database",
		},
		ER_DUP_ENTRY: {
			status: 409,
			type: "error",
			message: "Duplicate entry",
		},
		ER_NO_REFERENCED_ROW_2: {
			status: 409,
			type: "error",
			message: "Foreign key constraint fails",
		},
		ER_ROW_IS_REFERENCED_2: {
			status: 409,
			type: "error",
			message: "Cannot delete or update a parent row",
		},
		ER_BAD_NULL_ERROR: {
			status: 409,
			type: "error",
			message: "Column cannot be null",
		},
		ER_BAD_FIELD_ERROR: {
			status: 409,
			type: "error",
			message: "Unknown column",
		},
		ER_PARSE_ERROR: {
			status: 409,
			type: "error",
			message: "You have an error in your SQL syntax",
		},
		ER_TRUNCATED_WRONG_VALUE_FOR_FIELD: {
			status: 409,
			type: "error",
			message: "Incorrect integer value",
		},
		ER_DATA_TOO_LONG: {
			status: 409,
			type: "error",
			message: "Data too long for column",
		},
		ER_DUP_FIELDNAME: {
			status: 409,
			type: "error",
			message: "Duplicate column name",
		},
		ER_BAD_TABLE_ERROR: {
			status: 409,
			type: "error",
			message: "Unknown table",
		},
		ER_NO_SUCH_TABLE: {
			status: 409,
			type: "error",
			message: "Table doesn't exist",
		},
		ER_BAD_DB_ERROR: {
			status: 409,
			type: "error",
			message: "Unknown database",
		},
		ER_WRONG_FIELD_WITH_GROUP: {
			status: 409,
			type: "error",
			message: "is not in GROUP BY clause",
		},
		ER_WRONG_GROUP_FIELD: {
			status: 409,
			type: "error",
			message: "can't be used in field list",
		},
		ER_WRONG_SUM_SELECT: {
			status: 409,
			type: "error",
			message: "Statement has sum functions and columns in same query",
		},
		ER_WRONG_VALUE_COUNT: {
			status: 409,
			type: "error",

			message: "Column count doesn't match value count",
		},
		ER_TOO_MANY_ROWS: {
			status: 409,
			type: "error",
			message: "Subquery returns more than 1 row",
		},
		ER_NOT_SUPPORTED_YET: {
			status: 409,
			type: "error",
			message: "This version of MySQL doesn't yet support",
		},
		ER_NON_UNIQ_ERROR: {
			status: 409,
			type: "error",
			message: "Not unique table/alias",
		},
		ER_NONEXISTING_GRANT: {
			status: 409,
			type: "error",
			message: "Nonexisting grant",
		},
		ER_TABLEACCESS_DENIED_ERROR: {
			status: 409,
			type: "error",
			message: "Access denied for user",
		},
		ER_WRONG_NUMBER_OF_COLUMNS_IN_SELECT: {
			status: 409,
			type: "error",
			message:
				"The used SELECT statements have a different number of columns",
		},
		ER_CANT_DO_THIS_DURING_AN_TRANSACTION: {
			status: 409,
			type: "error",
			message: "Can't do this during an transaction",
		},
		ER_ERROR_DURING_COMMIT: {
			status: 409,
			type: "error",
			message: "Error during commit",
		},
		ER_ERROR_DURING_ROLLBACK: {
			status: 409,
			type: "error",
			message: "Error during rollback",
		},
		ER_ERROR_DURING_FLUSH_LOGS: {
			status: 409,
			type: "error",
			message: "Error during flush logs",
		},
		ER_ERROR_DURING_CHECKPOINT: {
			status: 409,
			type: "error",
			message: "Error during checkpoint",
		},
		ER_NEW_ABORTING_CONNECTION: {
			status: 409,
			type: "error",
			message: "Aborting connection",
		},
		ER_MASTER: {
			status: 409,
			type: "error",
			message: "Error messages from the master",
		},
		ER_MASTER_NET_READ: {
			status: 409,
			type: "error",
			message: "Net error reading from master",
		},
		ER_MASTER_NET_WRITE: {
			status: 409,
			type: "error",
			message: "Net error writing to master",
		},
		ER_FT_MATCHING_KEY_NOT_FOUND: {
			status: 409,
			type: "error",
			message: "Can't find FULLTEXT index matching the column list",
		},
		ER_LOCK_OR_ACTIVE_TRANSACTION: {
			status: 409,
			type: "error",
			message: "Lock wait timeout exceeded; try restarting transaction",
		},
		ER_WRONG_VALUE_COUNT_ON_ROW: {
			status: 409,
			type: "error",
			message: "Column count doesn't match value count at row",
		},
	};

	const result = (await response[operation]) || results;

	await res.status(result.status || 200).json(result);
};

// operation = "add" | "update" | "delete" | "NO_RESULTS" | "ER_ENTRY" | "ER_CONNECTION"
const ExecuteQuery = async (res, query, val = [], operation = "", msg = "") => {
	db.getConnection(async (err, connection) => {
		if (err) return await SendResponse(res, "ER_CONNECTION");

		connection.query(query, [...val], async (error, results) => {
			connection.release();
			if (error) return await SendResponse(res, error.code);
			if (results?.length === 0)
				return await SendResponse(res, "NO_RESULTS");

			await SendResponse(res, operation, results, msg);
		});
	});
};

module.exports = Object.freeze({
	db,
	SendResponse,
	ExecuteQuery,
	server,
});
