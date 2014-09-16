r     = require 'rethinkdb'
_     = require 'lodash'
Query = require './Query'

class MultipleResultQuery extends Query

  execute: (conn, callback) ->
    {query, enrichers} = @buildQuery()
    @runQuery conn, query, enrichers, (err, cursor) =>
      return callback(err) if err?
      cursor.close()
      callback null, _.map cursor, (item) => @mapResult(item)

  createSubqueryFunction: (property) ->
    name  = property.name
    table = property.type.schema.table
    field = property.options.foreignField ? 'id'
    return (conn, parentDocuments, callback) =>
      ids   = _.flatten _.pluck(parentDocuments, name)
      query = r.table(table).getAll(r.args(ids), {index: field})
      query.run conn, (err, childDocuments) ->
        return callback(err) if err?
        childDocuments = _.object _.map childDocuments, (item) -> [item[field], item]
        _.each parentDocuments, (parent) ->
          parent[name] = _.map parent[name], (id) -> childDocuments[id]
        callback()

module.exports = MultipleResultQuery
