Model = require 'domain/framework/Model'

class TokenModel extends Model

  constructor: (token) ->
    super(token)
    @creator = token.creator
    @comment = token.comment ? null

module.exports = TokenModel
