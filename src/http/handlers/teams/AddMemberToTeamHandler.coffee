Handler                = require 'http/framework/Handler'
AddMemberToTeamCommand = require 'domain/commands/teams/AddMemberToTeamCommand'

class AddMemberToTeamHandler extends Handler

  @route 'post /api/{orgid}/teams/{teamid}/members'

  @pre [
    'resolve org'
    'resolve team'
    'resolve user argument'
    'ensure team belongs to org'
    'ensure requester is member of org'
    'ensure user is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, team, user} = request.pre
    requester         = request.auth.credentials.user

    unless user?
      return reply @error.badRequest("Missing required argument 'user'")

    command = new AddMemberToTeamCommand(requester, team, user)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = AddMemberToTeamHandler
