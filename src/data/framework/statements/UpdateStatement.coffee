_         = require 'lodash'
r         = require 'rethinkdb'
Document  = require 'data/Document'
Error     = require 'data/Error'
Statement = require './Statement'

class UpdateStatement extends Statement

  constructor: (@schema, match, patch, expectedVersion = undefined) ->

    # TODO: We need a better way of handling the version increment for functions.
    unless _.isFunction(patch)
      patch = _.extend patch, {version: r.row('version').add(1)}

    if @expectedVersion?
      patch = (row) =>
        r.branch(
          row('version').eq(@expectedVersion),
          patch,
          r.error(Error.VersionMismatch)
        )

    @rql = r.table(@schema.table).get(match).update(patch, {returnChanges: true})

  run: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      return callback(response.first_error) if response.first_error?
      return callback(Error.DocumentNotFound) if response.replaced == 0 and response.unchanged == 0
      document = new Document(@schema, response.changes[0].new_val)
      if response.changes[0].old_val?
        previous = new Document(@schema, response.changes[0].old_val)
      callback(null, document, previous)

module.exports = UpdateStatement
