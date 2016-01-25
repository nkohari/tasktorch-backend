Handler           = require 'apps/api/framework/Handler'
DeleteGoalCommand = require 'domain/commands/goals/DeleteGoalCommand'

class DeleteGoalHandler extends Handler

  @route 'delete /{orgid}/goals/{goalid}'

  @before [
    'resolve org'
    'resolve goal'
    'ensure org has active subscription'
    'ensure goal belongs to org'
    'ensure requester can access goal'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, goal} = request.pre
    {user}      = request.auth.credentials

    command = new DeleteGoalCommand(user, goal)
    @processor.execute command, (err, goal) =>
      return reply err if err?
      return reply @response(goal)

module.exports = DeleteGoalHandler
