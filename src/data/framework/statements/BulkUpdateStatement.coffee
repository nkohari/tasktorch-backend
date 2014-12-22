_         = require 'lodash'
r         = require 'rethinkdb'
Document  = require 'data/Document'
Error     = require 'data/Error'
Statement = require './Statement'

class BulkUpdateStatement extends Statement

  constructor: (@schema, match, patch) ->
    patch = _.extend patch, {version: r.row('version').add(1)}
    @rql = match.update(patch, {returnChanges: true})

  execute: (conn, callback) ->
    console.log(@rql.toString())
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      return callback(response.first_error)   if response.first_error?
      return callback(Error.DocumentNotFound) if response.replaced == 0 and response.unchanged == 0
      documents = _.map response.changes, (change) => new Document(@schema, change.new_val)
      callback(null, documents)

module.exports = BulkUpdateStatement
