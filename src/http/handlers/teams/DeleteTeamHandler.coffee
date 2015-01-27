_                 = require 'lodash'
Handler           = require 'http/framework/Handler'
Response          = require 'http/framework/Response'
DeleteTeamCommand = require 'domain/commands/team/DeleteTeamCommand'

class DeleteTeamHandler extends Handler

  @route 'delete /api/{organizationId}/teams/{teamId}'

  @prereqs {
    organization: 'ResolveOrganization'
    team:         'ResolveTeam'
  }

  constructor: (@processor) ->

  handle: (request, reply) ->

    requester = request.auth.credentials.user
    {organization, team} = request.pre

    # Ensure that the team is part of the organization.
    unless team.organization == organization.id
      return reply @error.notFound()

    # Ensure that the requester is a member of the organization.
    unless _.contains(organization.members, requester.id)
      return reply @error.forbidden()

    # Ensure that the requester is a member of the team.
    unless _.contains(team.members, requester.id)
      return reply @error.forbidden()

    command = new DeleteTeamCommand(requester, request.pre.team)
    @processor.execute command, (err) =>
      return reply err if err?
      return reply()

module.exports = DeleteTeamHandler
