_                           = require 'lodash'
Handler                     = require 'http/framework/Handler'
Response                    = require 'http/framework/Response'
RemoveMemberFromTeamCommand = require 'domain/commands/team/RemoveMemberFromTeamCommand'

class RemoveMemberFromTeamHandler extends Handler

  @route 'delete /api/{orgId}/teams/{teamId}/members/{userId}'

  @prereqs {
    org:  'ResolveOrg'
    team: 'ResolveTeam'
    user: 'ResolveUser'
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

    # Ensure that the user we're removing is a member of the team.
    unless _.contains(team.members, user.id)
      return reply @error.badRequest()

    command = new RemoveMemberFromTeamCommand(request.auth.credentials.user, team, user)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply new Response(result.team)

module.exports = RemoveMemberFromTeamHandler
