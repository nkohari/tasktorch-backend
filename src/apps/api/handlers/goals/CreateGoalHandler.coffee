Handler           = require 'apps/api/framework/Handler'
Goal              = require 'data/documents/Goal'
CreateGoalCommand = require 'domain/commands/goals/CreateGoalCommand'

class CreateGoalHandler extends Handler

  @route 'post /{orgid}/goals'

  @ensure
    payload:
      name:        @mustBe.string().required()
      description: @mustBe.string().allow(null, '')
      timeframe:   @mustBe.object().keys(from: @mustBe.date(), to: @mustBe.date())

  @before [
    'resolve org'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org}  = request.pre
    {user} = request.auth.credentials
    {name, description, timeframe} = request.payload

    goal = new Goal {
      org:         org.id
      name:        name
      description: description ? null
      timeframe:   timeframe   ? null
    }

    command = new CreateGoalCommand(user, goal)
    @processor.execute command, (err, goal) =>
      return reply err if err?
      reply @response(goal)

module.exports = CreateGoalHandler
