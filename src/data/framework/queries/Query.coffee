util                 = require 'util'
_                    = require 'lodash'
r                    = require 'rethinkdb'
RelationType         = require 'data/RelationType'
QueryResult          = require 'data/QueryResult'
ExpansionTreeBuilder = require 'data/framework/ExpansionTreeBuilder'

class Query

  @requiredFields: ['id', 'version']

  constructor: (@schema, @options = {}) ->
    @expansions = []
    @pluck(@options.pluck)   if @options.pluck?
    @expand(@options.expand) if @options.expand?

  pluck: (fields...) ->
    @fields = _.flatten(fields)

  expand: (fields...) ->
    @expansions = @expansions.concat _.flatten(fields)

  execute: (conn, callback) ->
    @_processExpansions() if @expansions?
    @_processPluck() if @fields?
    console.log(@rql.toString())
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

  _processPluck: ->
    @rql = @rql.pluck Query.requiredFields.concat(@fields)

  _processExpansions: ->
    return unless @expansions.length > 0
    tree = ExpansionTreeBuilder.build(@schema, @expansions)
    @rql = @rql.do (result) ->
      expanded = result
      for field, expansion of tree
        expanded = expanded.merge(expansion.getMergeFunction())
      r.branch(result.eq(null), null, expanded)

module.exports = Query
