Handler                   = require 'apps/api/framework/Handler'
RemoveCardFromGoalCommand = require 'domain/commands/cards/RemoveCardFromGoalCommand'

class RemoveCardFromGoalHandler extends Handler

  @route 'delete /{orgid}/cards/{cardid}/goals/{goalid}'

  @before [
    'resolve org'
    'resolve goal'
    'resolve card'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure goal belongs to org'
    'ensure requester can access goal'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, goal, card} = request.pre
    {user}            = request.auth.credentials

    command = new RemoveCardFromGoalCommand(user, goal, card)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = RemoveCardFromGoalHandler
