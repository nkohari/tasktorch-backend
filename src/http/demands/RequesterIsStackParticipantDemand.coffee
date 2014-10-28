GetStackQuery = require 'data/queries/GetStackQuery'
Demand        = require '../framework/Demand'

class RequesterIsStackParticipantDemand extends Demand

  constructor: (@log, @database) ->

  execute: (request, reply) ->
    {user}    = request.auth.credentials
    {stackId} = request.params
    query = new GetStackQuery(stackId, {expand: 'team'})
    @database.execute query, (err, stack) =>
      return reply err if err?
      return reply @error.notFound() unless stack?
      request.scope.stack = stack
      if stack.owner? and stack.owner == user.id
        return reply()
      else if stack.team? and _.contains(stack.team.members, user.id)
        return reply()
      else
        return reply @error.unauthorized()

module.exports = RequesterIsStackParticipantDemand
