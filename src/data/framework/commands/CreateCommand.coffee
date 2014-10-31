r       = require 'rethinkdb'
_       = require 'lodash'
uuid    = require 'common/util/uuid'
Command = require './Command'

class CreateCommand extends Command

  constructor: (schema, data) ->
    @document = _.extend data, {id: uuid(), version: 0}
    @rql = r.table(schema.table).insert(@document)

  execute: (dbConnection, callback) ->
    @rql.run dbConnection, (err, results) =>
      return callback(err) if err?
      callback(null, @document)

module.exports = CreateCommand
