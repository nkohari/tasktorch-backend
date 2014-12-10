r        = require 'rethinkdb'
_        = require 'lodash'
uuid     = require 'common/util/uuid'
Command  = require './Command'
Document = require '../Document'

class CreateCommand extends Command

  constructor: (@schema, data) ->
    @data = _.extend data, {id: uuid(), version: 0}
    @rql  = r.table(@schema.table).insert(@data)

  execute: (dbConnection, callback) ->
    @rql.run dbConnection, (err, results) =>
      return callback(err) if err?
      callback null, new Document(@schema, @data)

module.exports = CreateCommand
