Request                    = require 'http/framework/Request'
StackType                  = require 'domain/enums/StackType'
GetCardQuery               = require 'data/queries/GetCardQuery'
GetSpecialStackByUserQuery = require 'data/queries/GetSpecialStackByUserQuery'

class AcceptCardRequest extends Request

  constructor: (@database) ->

  interpret: (request, callback) ->
    @getCardWithOrganization request.params.cardId, (err, card, organization) =>
      return callback(err) if err?
      return callback @error.notFound() unless card.organization == organization.id
      @getQueueStack organization, request.auth.credentials.user, (err, stack) =>
        return callback(err) if err?
        @user         = request.auth.credentials.user
        @organization = organization
        @card         = card
        @stack        = stack
        callback()

  getCardWithOrganization: (cardId, callback) ->
    query = new GetCardQuery(cardId, {expand: 'organization'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.notFound() unless result.card?
      card = result.card
      organization = result.related.organizations[card.organization]
      callback(null, card, organization)

  getQueueStack: (organization, user, callback) ->
    query = new GetSpecialStackByUserQuery(organization.id, user.id, StackType.Queue)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.badRequest() unless result.stack?
      callback(null, result.stack)

module.exports = AcceptCardRequest
