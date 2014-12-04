Model = require 'http/framework/Model'

class CardModel extends Model

  @describes: 'Card'
  @getUri: (id, request) -> "#{request.scope.organization.id}/cards/#{id}"

  load: (card) ->
    @title = card.title
    @body = card.body
    @kind = @one('kind', card.kind)
    @creator = @one('creator', card.creator)
    @owner = @one('owner', card.owner) if card.owner?
    @participants = @many('participants', card.participants)
    @stack = @one('stack', card.stack)
    @actions = @many('actions', card.actions)
    @goal = @one('goal', card.goal) if card.goal?
    @milestone = @one('milestone', card.milestone) if card.milestone?
    @lastHandoff = @one('lastHandoff', card.lastHandoff) if card.lastHandoff?

module.exports = CardModel
