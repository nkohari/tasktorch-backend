GetQuery = require 'data/framework/queries/GetQuery'
Session  = require 'data/documents/Session'

class GetSessionQuery extends GetQuery

  constructor: (id, options) ->
    super(Session, id, options)

module.exports = GetSessionQuery
