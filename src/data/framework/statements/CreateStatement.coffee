_         = require 'lodash'
r         = require 'rethinkdb'
uuid      = require 'common/util/uuid'
Document  = require 'data/Document'
Statement = require './Statement'

class CreateStatement extends Statement

  constructor: (@schema, data) ->
    data = _.extend data, {id: uuid(), version: 0}
    @rql = r.table(schema.table).insert(data, {returnChanges: true})

  execute: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      document = new Document(@schema, response.changes[0].new_val)
      callback(null, document)

module.exports = CreateStatement
