Demand = require '../framework/Demand'

class IsStackParticipantDemand extends Demand

  constructor: (@log, @stackService) ->

  execute: (request, reply) ->
    {stackId} = request.params
    @stackService.get stackId, {expand: 'team'}, (err, stack) =>
      return reply err if err?
      return reply @error.notFound() unless stack?
      request.scope.stack = stack
      user = request.auth.credentials.user
      if stack.owner?.equals(user) or stack.team?.members.any((m) -> m.equals(user))
        return reply()
      else
        return reply @error.unauthorized()

module.exports = IsStackParticipantDemand
