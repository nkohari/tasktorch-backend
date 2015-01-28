Handler                    = require 'http/framework/Handler'
StackType                  = require 'domain/enums/StackType'
GetInboxByTeamQuery        = require 'data/queries/stacks/GetInboxByTeamQuery'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'
PassCardCommand            = require 'domain/commands/cards/PassCardCommand'

class PassCardHandler extends Handler

  @route 'put /api/{orgid}/cards/{cardid}/pass'

  @pre [
    'resolve org'
    'resolve card'
    'resolve optional team argument'
    'resolve optional user argument'
    'ensure requester is member of org'
    'ensure team belongs to org'
    'ensure user is member of org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, team, user} = request.pre

    if team? and user?
      return reply @error.badRequest("You cannot specify both a team and a user")
    else if user?
      query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Inbox)
    else if team?
      query = new GetInboxByTeamQuery(team.id)

    @database.execute query, (err, {stack}) =>
      return reply err if err?
      command = new PassCardCommand(request.auth.credentials.user, card, stack)
      @processor.execute command, (err, result) =>
        return reply err if err?
        reply @response(result.card)

module.exports = PassCardHandler
