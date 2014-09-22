Card       = require 'data/entities/Card'
CardModel  = require '../models/CardModel'
Controller = require '../framework/Controller'

class CardController extends Controller

  constructor: (@log, @cardService) ->

  get: (request, reply) ->
    {cardId} = request.params
    expand   = request.query.expand.split(',') if request.query.expand?.length > 0
    @cardService.get cardId, {expand}, (err, card) =>
      return reply @error(err) if err?
      return reply @notFound() unless card?
      reply new CardModel(card)

  search: (request, reply) ->
    reply('search')

  create: (request, reply) ->
    reply('create')

  pass: (request, reply) ->
    reply('pass')

  delete: (request, reply) ->
    reply('delete')

module.exports = CardController
