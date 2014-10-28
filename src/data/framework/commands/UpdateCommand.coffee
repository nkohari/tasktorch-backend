r       = require 'rethinkdb'
Error   = require 'data/Error'
Command = require './Command'

class UpdateCommand extends Command

  constructor: (schema, id, diff, @expectedVersion) ->
    # TODO: Allow expectedVersion to be null
    updateIfCorrectVersion = (row) =>
      r.branch(
        row('version').eq(@expectedVersion),
        r.expr({}).merge(diff, {version: row('version').add(1)}),
        r.error(Error.VersionMismatch)
      )
    @rql = r.table(schema.table)
    .getAll(id)
    .update(updateIfCorrectVersion, {returnChanges: true})

  execute: (dbConnection, callback) ->
    @rql.run dbConnection, (err, result) =>
      return callback(err)                    if err?
      return callback(result.first_error)     if result.first_error?
      return callback(Error.DocumentNotFound) unless result.replaced == 1 or result.unchanged == 1
      [current, previous] = [result.changes[0].new_val, result.changes[0].old_val]
      callback(null, current, previous)

module.exports = UpdateCommand
