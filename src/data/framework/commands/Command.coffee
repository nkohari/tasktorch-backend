class Command

  execute: (dbConnection, callback) ->
    throw new Error("You must implement execute() on #{@constructor.name}")

module.exports = Command
