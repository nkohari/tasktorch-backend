_ = require 'lodash'

class Query

  constructor: (@options = {}) ->

  execute: (conn, callback) ->
    @beforeExecute()
    @rql.run conn, (err, result) =>
      return callback(err) if err?
      @processResult(result, callback)

  beforeExecute: ->

  processResult: (result, callback) ->
    return callback(null, @processResultItem(result)) unless result.toArray?
    result.toArray (err, items) =>
      return callback(err) if err?
      callback null, _.map items, (item) => @processResultItem(item)

  processResultItem: (item) ->
    return item

module.exports = Query
