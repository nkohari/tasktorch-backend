_                   = require 'lodash'
IdQuery             = require './queries/IdQuery'
SecondaryIndexQuery = require './queries/SecondaryIndexQuery'

interpret = (varargs) ->
  if varargs.length == 2
    [options, callback] = varargs
  else
    options = {}
    [callback] = varargs
  {options, callback}

class Service

  @type: (type) ->
    @prototype.type = type

  constructor: (@database, @eventBus) ->

  get: (id, varargs...) ->
    {options, callback} = interpret(varargs)
    query = new IdQuery(@type, id)
    query.expand(options.expand) if options.expand?
    @database.execute(query, callback)

  getBy: (hash, varargs...) ->
    {options, callback} = interpret(varargs)
    index = _.first _.keys(hash)
    query = new SecondaryIndexQuery(@type, index, hash[index])
    query.expand(options.expand) if options.expand?
    @database.execute(query, callback)

module.exports = Service
