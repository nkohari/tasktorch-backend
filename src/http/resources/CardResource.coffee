Card      = require 'data/entities/Card'
CardModel = require '../models/CardModel'
Resource  = require '../framework/Resource'

class CardResource extends Resource

  constructor: (@log, @cardService) ->

  get: (request, reply) ->
    {cardId} = request.params
    @cardService.get cardId, ['owner', 'participants'], (err, card) =>
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

module.exports = CardResource
