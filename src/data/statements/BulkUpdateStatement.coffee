_         = require 'lodash'
r         = require 'rethinkdb'
Error     = require 'data/framework/Error'
Statement = require 'data/framework/Statement'

class BulkUpdateStatement extends Statement

  constructor: (@doctype, match, patch) ->
    super(doctype)
    patch = _.extend patch, {version: r.row('version').add(1)}
    @rql = match.update(patch, {returnChanges: true})

  run: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      return callback(response.first_error) if response.first_error?
      documents = _.map response.changes, (change) => new @doctype(change.new_val)
      callback(null, documents)

module.exports = BulkUpdateStatement
