GetQuery = require 'data/framework/queries/GetQuery'
Session  = require 'data/schemas/Session'

class GetSessionQuery extends GetQuery

  constructor: (id, options) ->
    super(Session, id, options)

module.exports = GetSessionQuery
