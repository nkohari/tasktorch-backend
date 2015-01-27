Request       = require 'http/framework/Request'
GetCardQuery  = require 'data/queries/GetCardQuery'
GetStackQuery = require 'data/queries/GetStackQuery'

class MoveCardRequest extends Request

  constructor: (@database) ->

  interpret: (request, callback) ->

    unless request.payload.stack?
      return callback @error.badRequest()

    @getCardWithOrg request.params.cardId, (err, card, org) =>
      return callback(err) if err?
      return callback @error.notFound() unless card.org == request.params.orgId
      @getStackWithTeam request.payload.stack, (err, stack, team) =>
        return callback(err) if err?
        return callback @error.notFound() unless stack.org == request.params.orgId
        @user     = request.auth.credentials.user
        @card     = card
        @org      = org
        @stack    = stack
        @team     = team
        @position = request.payload.position ? 'append'
        callback()

  getCardWithOrg: (cardId, callback) ->
    query = new GetCardQuery(cardId, {expand: 'org'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.notFound() unless result.card?
      card = result.card
      org  = result.related.orgs[card.org]
      callback(null, card, org)

  getStackWithTeam: (stackId, callback) ->
    query = new GetStackQuery(stackId, {expand: 'team'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.badRequest() unless result.stack?
      stack = result.stack
      team  = result.related.teams[stack.team] if stack.team?
      callback(null, stack, team)

module.exports = MoveCardRequest
