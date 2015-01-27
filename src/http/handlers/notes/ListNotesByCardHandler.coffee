_                      = require 'lodash'
Handler                = require 'http/framework/Handler'
Response               = require 'http/framework/Response'
GetCardQuery           = require 'data/queries/GetCardQuery'
GetAllNotesByCardQuery = require 'data/queries/GetAllNotesByCardQuery'

class ListNotesByCardHandler extends Handler

  @route 'get /api/{orgId}/cards/{cardId}/notes'

  constructor: (@database) ->

  handle: (request, reply) ->
    @prepare request, [@getCardWithOrg], (err) =>
      return reply err if err?
      @validate request, (err) =>
        return reply err if err?
        query = new GetAllNotesByCardQuery(request.card.id, @getQueryOptions(request))
        @database.execute query, (err, result) =>
          return reply err if err?
          reply new Response(result)

  validate: (request, callback) ->
    if request.org.id != request.params.orgId
      return callback @error.forbidden()
    unless _.contains(request.org.members, request.auth.credentials.user.id)
      return callback @error.forbidden()
    callback()

  getCardWithOrg: (request, callback) ->
    query = new GetCardQuery(request.params.cardId, {expand: 'org'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      {card} = result
      return callback @error.notFound() unless card?
      request.card = card
      request.org = result.related.orgs[card.org]
      callback()

module.exports = ListNotesByCardHandler
