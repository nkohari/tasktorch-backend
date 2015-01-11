Request       = require 'http/framework/Request'
GetCardQuery  = require 'data/queries/GetCardQuery'
GetStackQuery = require 'data/queries/GetStackQuery'

class MoveCardRequest extends Request

  constructor: (@database) ->

  interpret: (request, callback) ->

    unless request.payload.stack?
      return callback @error.badRequest()

    @getCardWithOrganization request.params.cardId, (err, card, organization) =>
      return callback(err) if err?
      return callback @error.notFound() unless card.organization == request.params.organizationId
      @getStackWithTeam request.payload.stack, (err, stack, team) =>
        return callback(err) if err?
        return callback @error.notFound() unless stack.organization == request.params.organizationId
        @user         = request.auth.credentials.user
        @card         = card
        @organization = organization
        @stack        = stack
        @team         = team
        @position     = request.payload.position ? 'append'
        callback()

  getCardWithOrganization: (cardId, callback) ->
    query = new GetCardQuery(cardId, {expand: 'organization'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.notFound() unless result.card?
      card = result.card
      organization = result.related.organizations[card.organization]
      callback(null, card, organization)

  getStackWithTeam: (stackId, callback) ->
    query = new GetStackQuery(stackId, {expand: 'team'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.badRequest() unless result.stack?
      stack = result.stack
      team  = result.related.teams[stack.team] if stack.team?
      callback(null, stack, team)

module.exports = MoveCardRequest
