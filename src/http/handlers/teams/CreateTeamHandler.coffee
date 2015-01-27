async             = require 'async'
_                 = require 'lodash'
Handler           = require 'http/framework/Handler'
Response          = require 'http/framework/Response'
CreateTeamCommand = require 'domain/commands/team/CreateTeamCommand'
Team              = require 'domain/documents/Team'

class CreateTeamHandler extends Handler

  @route 'post /api/{orgId}/teams'

  @prereqs {
    org:     'ResolveOrg'
    members: 'ResolveMembersArgument'
    leaders: 'ResolveLeadersArgument'
  }

  constructor: (@log, @processor) ->

  handle: (request, reply) ->

    unless _.contains(request.pre.org.members, request.auth.credentials.user.id)
      return @error.forbidden()

    # TODO: Check members and leaders to ensure they are org members

    unless request.payload.name?.length > 0
      return @error.badRequest()

    team = new Team {
      org:     request.pre.org.id
      name:    request.payload.name
      members: _.pluck(request.pre.members, 'id')
      leaders: _.pluck(request.pre.leaders, 'id')
    }

    command = new CreateTeamCommand(request.auth.credentials.user, team)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply new Response(result.team)

module.exports = CreateTeamHandler
