_ = require 'lodash'

class Query

  constructor: (@options = {}) ->

  execute: (conn, callback) ->
    @beforeExecute()
    @rql.run conn, (err, result) =>
      return callback(err) if err?
      return callback(null, @processResult(result)) unless result.toArray?
      result.toArray (err, items) =>
        return callback(err) if err?
        callback null, _.map items, (item) => @processResult(item)

  beforeExecute: ->

  processResult: (result) ->
    return result

module.exports = Query
