_                 = require 'lodash'
Handler           = require 'http/framework/Handler'
Team              = require 'data/documents/Team'
CreateTeamCommand = require 'domain/commands/teams/CreateTeamCommand'

class CreateTeamHandler extends Handler

  @route 'post /api/{orgid}/teams'

  @pre [
    'resolve org'
    'resolve members argument'
    'resolve leaders argument'
    'ensure requester is member of org'
  ]

  constructor: (@log, @processor) ->

  handle: (request, reply) ->

    {org, members, leaders} = request.pre
    {user}                  = request.auth.credentials
    {name}                  = request.payload

    unless name?.length > 0
      return @error.badRequest("Missing required argument 'name'")

    if members?.length > 0 and not _.every(members, (u) -> _.contains(org.members, u.id))
      return @error.badRequest("All users in the 'members' list must be members of the organization")

    if leaders?.length > 0 and not _.every(leaders, (u) -> _.contains(org.members, u.id))
      return @error.badRequest("All users in the 'leaders' list must be members of the organization")

    team = new Team {
      org:     org.id
      name:    name
      members: _.pluck(members, 'id')
      leaders: _.pluck(leaders, 'id')
    }

    command = new CreateTeamCommand(user, team)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = CreateTeamHandler
