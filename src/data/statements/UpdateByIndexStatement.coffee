_         = require 'lodash'
r         = require 'rethinkdb'
Error     = require 'data/framework/Error'
Statement = require 'data/framework/Statement'

class UpdateByIndexStatement extends Statement

  constructor: (doctype, tuple, patch, options = {}) ->
    super(doctype)
    options = _.extend options, {returnChanges: true}

    unless _.isFunction(patch)
      patch = _.extend patch, {
        version: r.row('version').add(1)
        updated: r.now()
      }

    index = _.first _.keys(tuple)
    value = tuple[index]
    @rql  = r.table(@schema.table).getAll(value, {index}).default([]).limit(1).update(patch, options)

  run: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      return callback(response.first_error) if response.first_error?
      return callback(Error.DocumentNotFound) if response.replaced == 0 and response.unchanged == 0
      document = new @doctype(response.changes[0].new_val)
      if response.changes[0].old_val?
        previous = new @doctype(response.changes[0].old_val)
      callback(null, document, previous)

module.exports = UpdateByIndexStatement
