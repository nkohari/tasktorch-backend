r     = require 'rethinkdb'
Query = require './Query'

class SingleResultQuery extends Query

  processResult: (result, callback) ->
    callback null, new @type(result)

  createSubqueryFunction: (property) ->
    name  = property.name
    table = property.type.schema.table
    field = property.options.foreignField ? 'id'
    return (conn, parentDocument, callback) =>
      ids = parentDocument[name]
      return callback(null, null) unless ids?
      query = r.table(table).getAll(r.args(ids), {index: field})
      query.run conn, (err, childDocuments) ->
        return callback(err) if err?
        parentDocument[name] = childDocuments
        callback()

module.exports = SingleResultQuery
