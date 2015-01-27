Request                    = require 'http/framework/Request'
StackType                  = require 'domain/enums/StackType'
GetCardQuery               = require 'data/queries/GetCardQuery'
GetSpecialStackByUserQuery = require 'data/queries/GetSpecialStackByUserQuery'

class AcceptCardRequest extends Request

  constructor: (@database) ->

  interpret: (request, callback) ->
    @getCardWithOrg request.params.cardId, (err, card, org) =>
      return callback(err) if err?
      return callback @error.notFound() unless card.org == org.id
      @getQueueStack org, request.auth.credentials.user, (err, stack) =>
        return callback(err) if err?
        @user         = request.auth.credentials.user
        @org = org
        @card         = card
        @stack        = stack
        callback()

  getCardWithOrg: (cardId, callback) ->
    query = new GetCardQuery(cardId, {expand: 'org'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.notFound() unless result.card?
      card = result.card
      org  = result.related.orgs[card.org]
      callback(null, card, org)

  getQueueStack: (org, user, callback) ->
    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Queue)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.badRequest() unless result.stack?
      callback(null, result.stack)

module.exports = AcceptCardRequest
