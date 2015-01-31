Handler               = require 'http/framework/Handler'
ChangeTeamNameCommand = require 'domain/commands/teams/ChangeTeamNameCommand'

class ChangeTeamNameHandler extends Handler

  @route 'post /api/{orgid}/teams/{teamid}/name'

  @pre [
    'resolve org'
    'resolve team'
    'ensure team belongs to org'
    'ensure requester is member of org'
    'ensure requester is member of team'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, team} = request.pre
    {user}      = request.auth.credentials
    {name}      = request.payload

    unless name?.length > 0
      return reply @error.badRequest("Missing required argument 'name'")

    command = new ChangeTeamNameCommand(user, team, name)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = ChangeTeamNameHandler
