r         = require 'rethinkdb'
Statement = require 'data/framework/statements/Statement'

class ChangesStatement extends Statement

  constructor: (doctype) ->
    super(doctype)
    @rql = r.table(@schema.table).changes()

  run: (conn, callback) ->
    @rql.run conn, (err, cursor) =>
      return callback(err) if err?
      return callback(null, cursor)

module.exports = ChangesStatement
