_                       = require 'lodash'
Handler                 = require 'apps/api/framework/Handler'
GoalStatus              = require 'data/enums/GoalStatus'
ChangeGoalStatusCommand = require 'domain/commands/goals/ChangeGoalStatusCommand'

class ChangeGoalStatusHandler extends Handler

  @route 'post /{orgid}/goals/{goalid}/status'

  @ensure
    payload:
      status: @mustBe.string().valid(_.keys(GoalStatus))

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
    {status}    = request.payload

    if goal.status == status
      return reply @error.badRequest("The goal already has status #{status}")

    command = new ChangeGoalStatusCommand(user, goal, status)
    @processor.execute command, (err, goal) =>
      return reply err if err?
      return reply @response(goal)

module.exports = ChangeGoalStatusHandler
