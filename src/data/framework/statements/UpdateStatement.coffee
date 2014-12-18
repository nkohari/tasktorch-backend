_         = require 'lodash'
r         = require 'rethinkdb'
Document  = require 'data/Document'
Error     = require 'data/Error'
Statement = require './Statement'

class UpdateStatement extends Statement

  constructor: (@schema, idExpression, diff, expectedVersion = undefined) ->

    diff = _.extend diff, {version: r.row('version').add(1)}

    if @expectedVersion?
      arg = (row) =>
        r.branch(
          row('version').eq(@expectedVersion),
          diff,
          r.error(Error.VersionMismatch)
        )
    else
      arg = diff

    @rql = r.table(schema.table).get(idExpression).update(arg, {returnChanges: true})

  execute: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      return callback(response.first_error)   if response.first_error?
      return callback(Error.DocumentNotFound) unless response.replaced == 1 or response.unchanged == 1
      document = new Document(@schema, response.changes[0].new_val)
      callback(null, document)

module.exports = UpdateStatement
