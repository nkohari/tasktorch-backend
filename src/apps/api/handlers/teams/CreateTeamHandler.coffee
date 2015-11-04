_                           = require 'lodash'
Handler                     = require 'apps/api/framework/Handler'
Team                        = require 'data/documents/Team'
CreateTeamCommand           = require 'domain/commands/teams/CreateTeamCommand'
GetAllMembershipsByOrgQuery = require 'data/queries/memberships/GetAllMembershipsByOrgQuery'

class CreateTeamHandler extends Handler

  @route 'post /{orgid}/teams'

  @ensure
    payload:
      name:    @mustBe.string().required()
      purpose: @mustBe.string()
      leaders: @mustBe.array().items(@mustBe.string())
      members: @mustBe.array().items(@mustBe.string())

  @before [
    'resolve org'
    'resolve members argument'
    'resolve leaders argument'
    'ensure requester can access org'
  ]

  constructor: (@log, @database, @processor) ->

  handle: (request, reply) ->

    {org, members, leaders} = request.pre
    {user}                  = request.auth.credentials
    {name, purpose}         = request.payload

    if members?.length > 0
      members = _.pluck(members, 'id')
    else
      members = [user.id]

    if leaders?.length > 0
      leaders = _.pluck(leaders, 'id')
    else
      leaders = [user.id]

    query = new GetAllMembershipsByOrgQuery(org.id)
    @database.execute query, (err, result) =>
      return reply err if err?

      userids = _.pluck(result.memberships, 'user')

      unless _.every(members, (id) -> _.contains(userids, id))
        return reply @error.badRequest("All users in the members list must be members of the org")

      unless _.every(leaders, (id) -> _.contains(userids, id))
        return reply @error.badRequest("All users in the leaders list must be members of the org")

      if _.difference(leaders, members).length > 0
        return reply @error.badRequest("The leaders list must be a proper subset of the members list")

      team = new Team {
        org:     org.id
        name:    name
        purpose: purpose
        members: members
        leaders: leaders
      }

      command = new CreateTeamCommand(user, team)
      @processor.execute command, (err, team) =>
        return reply err if err?
        return reply @response(team)

module.exports = CreateTeamHandler
