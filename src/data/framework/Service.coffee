IdQuery = require './queries/IdQuery'

class Service

  @type: (type) ->
    @prototype.type = type

  constructor: (@database) ->

  get: (id, expansions, callback) ->
    query = new IdQuery(@type, id)
    query.expand(expansions)
    @database.execute(query, callback)

module.exports = Service
