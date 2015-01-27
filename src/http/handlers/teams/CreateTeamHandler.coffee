async             = require 'async'
_                 = require 'lodash'
Handler           = require 'http/framework/Handler'
Response          = require 'http/framework/Response'
CreateTeamCommand = require 'domain/commands/team/CreateTeamCommand'
Team              = require 'domain/documents/Team'

class CreateTeamHandler extends Handler

  @route 'post /api/{organizationId}/teams'

  @prereqs {
    organization: 'ResolveOrganization'
    members:      'ResolveMembersArgument'
    leaders:      'ResolveLeadersArgument'
  }

  constructor: (@log, @processor) ->

  handle: (request, reply) ->

    team = new Team {
      organization: request.pre.organization.id
      name:         request.payload.name
      members:      _.pluck(request.pre.members, 'id')
      leaders:      _.pluck(request.pre.leaders, 'id')
    }

    err = @validate(request, team)
    return reply err if err?

    command = new CreateTeamCommand(request.auth.credentials.user, team)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply new Response(result.team)

  validate: (request, team) ->
    unless _.contains(request.pre.organization.members, request.auth.credentials.user.id)
      return @error.forbidden()
    unless team.name?.length > 0
      return @error.badRequest()

module.exports = CreateTeamHandler
