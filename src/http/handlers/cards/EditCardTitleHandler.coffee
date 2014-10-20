{Card}     = require 'data/entities'
{GetQuery} = require 'data/queries'
CardModel  = require '../../models/CardModel'
Handler    = require '../../framework/Handler'

class EditCardTitleHandler extends Handler

  @route 'post /api/{organizationId}/cards/{cardId}/title'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {cardId} = request.params
    {title}  = request.payload
    query = new GetQuery(Card, cardId)
    @database.execute query, (err, card) =>
      return reply err if err?
      return reply @error.notFound() unless card?
      card.setTitle(title)
      @database.update card, (err) =>
        return reply err if err?
        reply()

module.exports = EditCardTitleHandler
