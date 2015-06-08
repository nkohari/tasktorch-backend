Handler           = require 'http/framework/Handler'
Goal              = require 'data/documents/Goal'
CreateGoalCommand = require 'domain/commands/goals/CreateGoalCommand'

class CreateGoalHandler extends Handler

  @route 'post /api/{orgid}/goals'

  @ensure
    payload:
      name: @mustBe.string().required()

  @before [
    'resolve org'
    'ensure requester can access org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org}  = request.pre
    {user} = request.auth.credentials
    {name} = request.payload

    goal = new Goal {
      org:  org.id
      name: name
    }

    command = new CreateGoalCommand(user, goal)
    @processor.execute command, (err, goal) =>
      return reply err if err?
      reply @response(goal)

module.exports = CreateGoalHandler
