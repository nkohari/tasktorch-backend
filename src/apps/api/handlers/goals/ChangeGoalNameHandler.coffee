Handler               = require 'apps/api/framework/Handler'
ChangeGoalNameCommand = require 'domain/commands/goals/ChangeGoalNameCommand'

class ChangeGoalNameHandler extends Handler

  @route 'post /{orgid}/goals/{goalid}/name'

  @ensure
    payload:
      name: @mustBe.string().required()

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
    {name}      = request.payload

    command = new ChangeGoalNameCommand(user, goal, name)
    @processor.execute command, (err, goal) =>
      return reply err if err?
      return reply @response(goal)

module.exports = ChangeGoalNameHandler
