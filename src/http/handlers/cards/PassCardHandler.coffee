Handler                    = require 'http/framework/Handler'
StackType                  = require 'data/enums/StackType'
GetInboxByTeamQuery        = require 'data/queries/stacks/GetInboxByTeamQuery'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'
PassCardCommand            = require 'domain/commands/cards/PassCardCommand'

class PassCardHandler extends Handler

  @route 'put /api/{orgid}/cards/{cardid}/pass'

  @validate
    payload:
      team: @mustBe.string()
      user: @mustBe.string()

  @pre [
    'resolve org'
    'resolve card'
    'resolve optional team argument'
    'resolve optional user argument'
    'ensure requester can access card'
    'ensure team argument belongs to org'
    'ensure user argument is member of org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {card, org, team, user} = request.pre

    if team? and user?
      return reply @error.badRequest("You cannot specify both a team and a user")
    else if user?
      query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Inbox)
    else if team?
      query = new GetInboxByTeamQuery(team.id)
    else
      return reply @error.badRequest("You must specify either a team or a user")

    @database.execute query, (err, result) =>
      return reply err if err?
      {stack} = result
      command = new PassCardCommand(request.auth.credentials.user, card, stack)
      @processor.execute command, (err, card) =>
        return reply err if err?
        reply @response(card)

module.exports = PassCardHandler
