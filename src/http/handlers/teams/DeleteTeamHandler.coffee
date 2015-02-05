Handler           = require 'http/framework/Handler'
DeleteTeamCommand = require 'domain/commands/teams/DeleteTeamCommand'

class DeleteTeamHandler extends Handler

  @route 'delete /api/{orgid}/teams/{teamid}'

  @pre [
    'resolve org'
    'resolve team'
    'ensure team belongs to org'
    'ensure requester can access team'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, team} = request.pre
    {user}      = request.auth.credentials

    command = new DeleteTeamCommand(user, team)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = DeleteTeamHandler
