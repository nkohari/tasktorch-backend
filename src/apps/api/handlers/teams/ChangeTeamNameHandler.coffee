Handler               = require 'apps/api/framework/Handler'
ChangeTeamNameCommand = require 'domain/commands/teams/ChangeTeamNameCommand'

class ChangeTeamNameHandler extends Handler

  @route 'post /{orgid}/teams/{teamid}/name'

  @ensure
    payload:
      name: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve team'
    'ensure org has active subscription'
    'ensure team belongs to org'
    'ensure requester can access team'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, team} = request.pre
    {user}      = request.auth.credentials
    {name}      = request.payload

    command = new ChangeTeamNameCommand(user, team, name)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = ChangeTeamNameHandler
