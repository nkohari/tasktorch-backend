util                 = require 'util'
_                    = require 'lodash'
r                    = require 'rethinkdb'
RelationType         = require 'data/RelationType'
DocumentStatus       = require 'data/DocumentStatus'
QueryResult          = require 'data/QueryResult'
ExpansionTreeBuilder = require 'data/framework/ExpansionTreeBuilder'

class Query

  @requiredFields: ['id', 'status', 'version']

  constructor: (@schema, @options = {}) ->
    @expansions = []
    @pluck(@options.pluck)   if @options.pluck?
    @expand(@options.expand) if @options.expand?

  pluck: (fields...) ->
    @fields = _.flatten(fields)

  expand: (fields...) ->
    @expansions = @expansions.concat _.flatten(fields)

  prepare: (conn, callback) ->
    @_addExpansionClause() if @expansions?
    @_addPluckClause()     if @fields?
    @_addStatusFilterClause()
    callback()

  run: (conn, callback) ->
    @rql.run conn, (err, response) =>
      return callback(err) if err?
      @preprocessResult response, (err, result) =>
        return callback(err) if err?
        callback null, new QueryResult(@schema, result)

  preprocessResult: (result, callback) ->
    if result?.toArray?
      result.toArray(callback)
    else
      callback(null, result)

  _addExpansionClause: ->
    return unless @expansions.length > 0
    tree = ExpansionTreeBuilder.build(@schema, @expansions)
    @rql = @rql.do (result) ->
      expanded = result
      for field, expansion of tree
        expanded = expanded.merge(expansion.getMergeFunction())
      r.branch(result.eq(null), null, expanded)

  _addPluckClause: ->
    @rql = @rql.pluck Query.requiredFields.concat(@fields)

  _addStatusFilterClause: ->
    @rql = @rql.do (result) ->
      r.branch(
        r.typeOf(result).eq('ARRAY'),
        result.filter (row) ->
          r.or(r.not(row.hasFields('status')), r.not(row('status').eq(DocumentStatus.Deleted)))
        r.branch(
          r.typeOf(result).eq('NULL'),
          null,
          r.branch(
            r.and(result.hasFields('status'), result('status').eq(DocumentStatus.Deleted)),
            null,
            result
          )
        )
      )

module.exports = Query
