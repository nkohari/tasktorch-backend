IdQuery = require './queries/IdQuery'

class Service

  @type: (type) ->
    @prototype.type = type

  constructor: (@database) ->

  get: (id, callback) ->
    query = new IdQuery(@type, id)
    @database.execute(query, callback)

module.exports = Service
