_              = require 'lodash'
r              = require 'rethinkdb'
uuid           = require 'common/util/uuid'
DocumentStatus = require 'data/enums/DocumentStatus'
Statement      = require 'data/framework/Statement'

class BulkCreateStatement extends Statement

  constructor: (doctype, documents) ->
    super(doctype)

    for document in documents
      document.id      ?= uuid()
      document.version ?= 0
      document.status  ?= DocumentStatus.Normal

    @rql = r.table(@schema.table).insert(documents, {returnChanges: true})

  run: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      documents = _.map response.changes, (item) => new @doctype(item.new_val)
      callback(null, documents)

module.exports = BulkCreateStatement
