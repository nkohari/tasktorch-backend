_                     = require 'lodash'
Handler               = require 'http/framework/Handler'
Response              = require 'http/framework/Response'
ChangeTeamNameCommand = require 'domain/commands/team/ChangeTeamNameCommand'

class ChangeTeamNameHandler extends Handler

  @route 'post /api/{orgId}/teams/{teamId}/name'

  @prereqs {
    org:  'ResolveOrg'
    team: 'ResolveTeam'
  }

  constructor: (@processor) ->

  handle: (request, reply) ->

    requester = request.auth.credentials.user
    {org, team} = request.pre

    # Ensure that the team is part of the org.
    unless team.org == org.id
      return reply @error.notFound()

    # Ensure that the requester is a member of the org.
    unless _.contains(org.members, requester.id)
      return reply @error.forbidden()

    # Ensure that the requester is a member of the team.
    unless _.contains(team.members, requester.id)
      return reply @error.forbidden()

    # Ensure that a new name was given.
    unless request.payload.name?.length > 0
      return reply @error.badRequest()

    command = new ChangeTeamNameCommand(requester, request.pre.team, request.payload.name)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply new Response(result.team)

module.exports = ChangeTeamNameHandler
