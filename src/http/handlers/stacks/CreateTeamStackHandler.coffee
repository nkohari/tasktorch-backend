Handler            = require 'http/framework/Handler'
Stack              = require 'data/documents/Stack'
StackType          = require 'data/enums/StackType'
CreateStackCommand = require 'domain/commands/stacks/CreateStackCommand'

class CreateTeamStackHandler extends Handler

  @route 'post /api/{orgid}/teams/{teamid}/stacks'

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

    stack = new Stack {
      org:  org.id
      type: StackType.Backlog
      name: name
      team: team.id
    }

    command = new CreateStackCommand(user, stack)
    @processor.execute command, (err, stack) =>
      return reply err if err?
      return reply @response(stack)

module.exports = CreateTeamStackHandler
