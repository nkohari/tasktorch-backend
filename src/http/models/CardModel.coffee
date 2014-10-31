Model = require 'http/framework/Model'

class CardModel extends Model

  @describes: 'Card'
  @getUri: (id, request) -> "#{request.scope.organization.id}/cards/#{id}"

  load: (card) ->
    @type = card.type
    @title = card.title
    @body = card.body
    @creator = @ref('creator', card.creator)
    @owner = @ref('owner', card.owner)
    @participants = @ref('participants', card.participants)
    @stack = @ref('stack', card.stack)

module.exports = CardModel
