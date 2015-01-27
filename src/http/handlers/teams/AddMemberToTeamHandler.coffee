_                      = require 'lodash'
Handler                = require 'http/framework/Handler'
Response               = require 'http/framework/Response'
AddMemberToTeamCommand = require 'domain/commands/team/AddMemberToTeamCommand'

class AddMemberToTeamHandler extends Handler

  @route 'post /api/{orgId}/teams/{teamId}/members'

  @prereqs {
    org:  'ResolveOrg'
    team: 'ResolveTeam'
    user: 'ResolveUserArgument'
  }

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, team, user} = request.pre

    # Ensure that the team is part of the org.
    unless team.org == org.id
      return reply @error.notFound()

    # Ensure that the requesting user is a member of the org.
    unless _.contains(org.members, request.auth.credentials.user.id)
      return reply @error.forbidden()

    # Ensure that the user we're adding is a member of the org.
    unless _.contains(org.members, user.id)
      return reply @error.badRequest()

    command = new AddMemberToTeamCommand(request.auth.credentials.user, request.pre.team, request.pre.user)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply new Response(result.team)

module.exports = AddMemberToTeamHandler
