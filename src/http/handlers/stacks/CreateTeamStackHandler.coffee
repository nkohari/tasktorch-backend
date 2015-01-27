async              = require 'async'
_                  = require 'lodash'
Handler            = require 'http/framework/Handler'
Response           = require 'http/framework/Response'
CreateStackCommand = require 'domain/commands/stack/CreateStackCommand'
Stack              = require 'domain/documents/Stack'
StackType          = require 'domain/enums/StackType'

class CreateTeamStackHandler extends Handler

  @route 'post /api/{organizationId}/teams/{teamId}/stacks'

  @prereqs {
    organization: 'ResolveOrganization'
    team:         'ResolveTeam'
  }

  constructor: (@log, @processor) ->

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

    # Ensure that a name was specified for the stack.
    unless request.payload.name?.length > 0
      return reply @error.badRequest()

    stack = new Stack {
      organization: organization.id
      type:         StackType.Backlog
      name:         request.payload.name
      team:         team.id
    }

    command = new CreateStackCommand(request.auth.credentials.user, stack)
    @processor.execute command, (err, result) =>
      return reply err if err?
      return reply new Response(result.stack)

module.exports = CreateTeamStackHandler
