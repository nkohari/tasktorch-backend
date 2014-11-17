_             = require 'lodash'
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
      team = stack['_related'].team
      stack = request.scope.stack = _.omit(stack, '_related')
      if stack.owner? and stack.owner == user.id
        return reply()
      else if team? and _.contains(team.members, user.id)
        return reply()
      else
        return reply @error.unauthorized()

module.exports = RequesterIsStackParticipantDemand
