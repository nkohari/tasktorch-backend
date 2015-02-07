Model = require 'domain/framework/Model'

class TokenModel extends Model

  constructor: (token) ->
    super(token)
    @creator = token.creator
    @org     = token.org
    @comment = token.comment ? null

module.exports = TokenModel
