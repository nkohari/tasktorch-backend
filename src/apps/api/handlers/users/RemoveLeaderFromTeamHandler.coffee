RemoveLeaderFromTeamCommand = require 'domain/commands/users/RemoveLeaderFromTeamCommand'
Handler                     = require 'apps/api/framework/Handler'

class RemoveLeaderFromTeamHandler extends Handler

  @route 'delete /{orgid}/teams/{teamid}/leaders/{userid}'

  @before [
    'resolve org'
    'resolve team'
    'resolve user'
    'ensure requester can access team'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, team, user} = request.pre
    requester         = request.auth.credentials.user

    unless team.hasLeader(user.id)
      return reply @error.badRequest("The user #{user.id} is not a leader of the team #{team.id}")

    command = new RemoveLeaderFromTeamCommand(requester, team, user)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = RemoveLeaderFromTeamHandler
