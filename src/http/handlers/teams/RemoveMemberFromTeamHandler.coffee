_                           = require 'lodash'
Handler                     = require 'http/framework/Handler'
RemoveMemberFromTeamCommand = require 'domain/commands/teams/RemoveMemberFromTeamCommand'

class RemoveMemberFromTeamHandler extends Handler

  @route 'delete /api/{orgid}/teams/{teamid}/members/{userid}'

  @pre [
    'resolve org'
    'resolve team'
    'resolve user'
    'ensure requester can access team'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, team, user} = request.pre
    requester         = request.auth.credentials.user

    unless team.hasMember(user.id)
      return reply @error.badRequest("The user #{user.id} is not a member of the team #{team.id}")

    command = new RemoveMemberFromTeamCommand(requester, team, user)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = RemoveMemberFromTeamHandler
