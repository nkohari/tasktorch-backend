_                 = require 'lodash'
Handler           = require 'http/framework/Handler'
Team              = require 'data/documents/Team'
CreateTeamCommand = require 'domain/commands/teams/CreateTeamCommand'

class CreateTeamHandler extends Handler

  @route 'post /api/{orgid}/teams'

  @ensure
    payload:
      name:    @mustBe.string().required()
      leaders: @mustBe.array().includes(@mustBe.string())
      members: @mustBe.array().includes(@mustBe.string())

  @before [
    'resolve org'
    'resolve members argument'
    'resolve leaders argument'
    'ensure requester can access org'
  ]

  constructor: (@log, @processor) ->

  handle: (request, reply) ->

    {org, members, leaders} = request.pre
    {user}                  = request.auth.credentials
    {name}                  = request.payload

    if members.length == 0
      members = [user]
    else if not _.every(members, (u) -> org.hasMember(u.id))
      return reply @error.badRequest("All users in the members list must be members of the org")

    if leaders.length == 0
      leaders = [user]
    else if not _.every(leaders, (u) -> org.hasMember(u.id))
      return reply @error.badRequest("All users in the leaders list must be members of the org")

    memberids = _.pluck(members, 'id')
    leaderids = _.pluck(leaders, 'id')

    if _.difference(leaderids, memberids).length > 0
      return reply @error.badRequest("The leaders list must be a proper subset of the members list")

    team = new Team {
      org:     org.id
      name:    name
      members: memberids
      leaders: leaderids
    }

    command = new CreateTeamCommand(user, team)
    @processor.execute command, (err, team) =>
      return reply err if err?
      return reply @response(team)

module.exports = CreateTeamHandler
