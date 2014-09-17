Card     = require 'data/entities/Card'
Resource = require '../framework/Resource'

class CardResource extends Resource

  constructor: (@log, @cardService) ->

  get: (request, reply) ->
    {cardId} = request.params
    @cardService.get cardId, (err, card) =>
      @log.inspect arguments
      return reply @error(err) if err?
      return reply @notFound() unless card?
      reply(card)

  search: (request, reply) ->
    reply('search')

  create: (request, reply) ->
    reply('create')

  pass: (request, reply) ->
    reply('pass')

  delete: (request, reply) ->
    reply('delete')

module.exports = CardResource
