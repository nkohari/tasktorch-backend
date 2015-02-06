GetQuery = require 'data/framework/queries/GetQuery'
Token    = require 'data/documents/Token'

class GetTokenQuery extends GetQuery

  constructor: (id, options) ->
    super(Token, id, options)

module.exports = GetTokenQuery
