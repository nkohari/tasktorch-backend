Handler                   = require 'http/framework/Handler'
RemoveCardFromGoalCommand = require 'domain/commands/cards/RemoveCardFromGoalCommand'

class RemoveCardFromGoalHandler extends Handler

  @route 'delete /api/{orgid}/goals/{goalid}/cards/{cardid}'

  @before [
    'resolve org'
    'resolve goal'
    'resolve card'
    'ensure card belongs to org'
    'ensure goal belongs to org'
    'ensure requester can access goal'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, goal, card} = request.pre
    {user}            = request.auth.credentials

    command = new RemoveCardFromGoalCommand(user, goal, card)
    @processor.execute command, (err, goal) =>
      return reply err if err?
      reply @response(goal)

module.exports = RemoveCardFromGoalHandler
