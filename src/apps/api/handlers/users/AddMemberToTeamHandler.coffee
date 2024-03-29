Handler                = require 'apps/api/framework/Handler'
AddMemberToTeamCommand = require 'domain/commands/users/AddMemberToTeamCommand'

class AddMemberToTeamHandler extends Handler

  @route 'post /{orgid}/teams/{teamid}/members'

  @ensure
    payload:
      user: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve team'
    'resolve user argument'
    'ensure org has active subscription'
    'ensure team belongs to org'
    'ensure requester can access team'
    'ensure user argument is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, team, user} = request.pre
    requester         = request.auth.credentials.user

    if team.hasMember(user)
      return reply @response(team)

    command = new AddMemberToTeamCommand(requester, team, user)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = AddMemberToTeamHandler
