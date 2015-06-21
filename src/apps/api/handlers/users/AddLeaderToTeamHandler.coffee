Handler                = require 'apps/api/framework/Handler'
AddLeaderToTeamCommand = require 'domain/commands/users/AddLeaderToTeamCommand'

class AddLeaderToTeamHandler extends Handler

  @route 'post /{orgid}/teams/{teamid}/leaders'

  @ensure
    payload:
      user: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve team'
    'resolve user argument'
    'ensure team belongs to org'
    'ensure requester can access team'
    'ensure user argument is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, team, user} = request.pre
    requester         = request.auth.credentials.user

    if team.hasLeader(user)
      return reply @response(team)

    command = new AddLeaderToTeamCommand(requester, team, user)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = AddLeaderToTeamHandler
