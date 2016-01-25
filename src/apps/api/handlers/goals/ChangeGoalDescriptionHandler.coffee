Handler                      = require 'apps/api/framework/Handler'
ChangeGoalDescriptionCommand = require 'domain/commands/goals/ChangeGoalDescriptionCommand'

class ChangeGoalDescriptionHandler extends Handler

  @route 'post /{orgid}/goals/{goalid}/description'

  @ensure
    payload:
      description: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve goal'
    'ensure org has active subscription'
    'ensure goal belongs to org'
    'ensure requester can access goal'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, goal}   = request.pre
    {user}        = request.auth.credentials
    {description} = request.payload

    command = new ChangeGoalDescriptionCommand(user, goal, description)
    @processor.execute command, (err, goal) =>
      return reply err if err?
      return reply @response(goal)

module.exports = ChangeGoalDescriptionHandler
