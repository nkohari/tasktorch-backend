_              = require 'lodash'
r              = require 'rethinkdb'
uuid           = require 'common/util/uuid'
Document       = require 'data/Document'
DocumentStatus = require 'data/DocumentStatus'
Statement      = require './Statement'

class CreateStatement extends Statement

  constructor: (@schema, data) ->
    data = _.extend {id: uuid(), version: 0, status: DocumentStatus.Normal}, data
    @rql = r.table(schema.table).insert(data, {returnChanges: true})

  run: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      document = new Document(@schema, response.changes[0].new_val)
      callback(null, document)

module.exports = CreateStatement