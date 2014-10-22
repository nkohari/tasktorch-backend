{Card}     = require 'data/entities'
{GetQuery} = require 'data/queries'
CardModel  = require '../../models/CardModel'
Handler    = require '../../framework/Handler'

class ChangeCardBodyHandler extends Handler

  @route 'post /api/{organizationId}/cards/{cardId}/body'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user}   = request.auth.credentials
    {cardId} = request.params
    {body}   = request.payload
    query = new GetQuery(Card, cardId)
    @database.execute query, (err, card) =>
      return reply err if err?
      return reply @error.notFound() unless card?
      card.setBody(user, body)
      @database.update card, (err) =>
        return reply err if err?
        reply()

module.exports = ChangeCardBodyHandler
