_             = require 'lodash'
GetQuery      = require '../queries/GetQuery'
MultiGetQuery = require '../queries/MultiGetQuery'
GetByQuery    = require '../queries/GetByQuery'

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
    query = new GetQuery(@type, id)
    query.expand(options.expand) if options.expand?
    @database.execute(query, callback)

  getBy: (hash, varargs...) ->
    {options, callback} = interpret(varargs)
    index = _.first _.keys(hash)
    query = new GetByQuery(@type, index, hash[index])
    query.expand(options.expand) if options.expand?
    @database.execute(query, callback)

  getAll: (ids, varargs...) ->
    {options, callback} = interpret(varargs)
    query = new MultiGetQuery(@type, ids)
    query.expand(options.expand) if options.expand?
    @database.execute(query, callback)

module.exports = Service
