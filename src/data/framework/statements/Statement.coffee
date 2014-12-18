class Statement

  execute: (conn, callback) ->
    throw new Error("You must implement execute() on #{@constructor.name}")

module.exports = Statement
