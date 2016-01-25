Handler                    = require 'apps/api/framework/Handler'
ChangeGoalTimeframeCommand = require 'domain/commands/goals/ChangeGoalTimeframeCommand'

class ChangeGoalTimeframeHandler extends Handler

  @route 'post /{orgid}/goals/{goalid}/timeframe'

  @ensure
    payload:
      timeframe: @mustBe.object().keys(from: @mustBe.date(), to: @mustBe.date()).allow(null)

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
    {timeframe} = request.payload

    command = new ChangeGoalTimeframeCommand(user, goal, timeframe)
    @processor.execute command, (err, goal) =>
      return reply err if err?
      return reply @response(goal)

module.exports = ChangeGoalTimeframeHandler
