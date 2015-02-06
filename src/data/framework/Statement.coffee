class Statement

  constructor: (@doctype) ->
    @schema = @doctype.getSchema()

  prepare: (conn, callback) ->
    callback()

  run: (conn, callback) ->
    throw new Error("You must implement run() on #{@constructor.name}")

module.exports = Statement
