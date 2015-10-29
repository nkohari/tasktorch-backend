_              = require 'lodash'
r              = require 'rethinkdb'
uuid           = require 'common/util/uuid'
DocumentStatus = require 'data/enums/DocumentStatus'
Statement      = require 'data/framework/Statement'

class CreateStatement extends Statement

  constructor: (document) ->
    super(document.constructor)

    timestamp = new Date()

    document.id      ?= uuid()
    document.version ?= 0                     if @schema.hasProperty('version')
    document.status  ?= DocumentStatus.Normal if @schema.hasProperty('status')
    document.created ?= timestamp             if @schema.hasProperty('created')
    document.updated ?= timestamp             if @schema.hasProperty('updated')

    @rql = r.table(@schema.table).insert(document, {returnChanges: true})

  run: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      document = new @doctype(response.changes[0].new_val)
      callback(null, document)

module.exports = CreateStatement
