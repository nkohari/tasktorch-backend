{Card}     = require 'data/entities'
{GetQuery} = require 'data/queries'
CardModel  = require '../../models/CardModel'
Handler    = require '../../framework/Handler'

class ChangeCardTitleHandler extends Handler

  @route 'post /api/{organizationId}/cards/{cardId}/title'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user}   = request.auth.credentials
    {cardId} = request.params
    {title}  = request.payload
    query = new GetQuery(Card, cardId)
    @database.execute query, (err, card) =>
      return reply err if err?
      return reply @error.notFound() unless card?
      card.setTitle(user, title)
      @database.update card, (err) =>
        return reply err if err?
        reply()

module.exports = ChangeCardTitleHandler
