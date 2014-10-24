Model = require '../framework/Model'

class CardModel extends Model

  getUri: (card, request) ->
    "#{request.scope.organization.id}/cards/#{card.id}"

  assignProperties: (card) ->
    @type = card.type
    @title = card.title
    @body = card.body
    @owner = @one('UserModel', card.owner)
    @participants = @many('UserModel', card.participants)
    @stack = @one('StackModel', card.stack)

module.exports = CardModel
