r       = require 'rethinkdb'
_       = require 'lodash'
uuid    = require 'common/uuid'
Command = require './Command'

class CreateCommand extends Command

  constructor: (schema, data) ->
    @document = _.extend data, {id: uuid.generate(), version: 0}
    @rql = r.table(schema.table).insert(@document)

  execute: (dbConnection, callback) ->
    @rql.run dbConnection, (err, results) =>
      return callback(err) if err?
      callback(null, @document)

module.exports = CreateCommand
