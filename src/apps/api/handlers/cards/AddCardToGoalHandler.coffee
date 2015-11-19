Handler              = require 'apps/api/framework/Handler'
AddCardToGoalCommand = require 'domain/commands/cards/AddCardToGoalCommand'

class AddCardToGoalHandler extends Handler

  @route 'post /{orgid}/cards/{cardid}/goals'

  @ensure
    payload:
      goal: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve card'
    'resolve goal argument'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure goal belongs to org'
    'ensure requester can access goal'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, goal, card} = request.pre
    {user}            = request.auth.credentials

    command = new AddCardToGoalCommand(user, goal, card)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = AddCardToGoalHandler
