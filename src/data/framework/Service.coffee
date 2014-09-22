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
    query = new SecondaryIndexQuery(@type, index, hash[value])
    query.expand(options.expand) if options.expand?
    @database.execute(query, callback)

  save: (entity, callback) ->
    @database.save(entity, callback)

  create: (entity, callback) ->
    @database.create(entity, callback)

  update: (entity, callback) ->
    @database.update(entity, callback)

  delete: (entity, callback) ->
    @database.delete(entity, callback)

  publish: (event) ->
    @eventBus.publish(event)

module.exports = Service
