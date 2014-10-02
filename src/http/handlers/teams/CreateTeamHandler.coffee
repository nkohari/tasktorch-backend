{Team}     = require 'data/entities'
{GetQuery} = require 'data/queries'
TeamModel  = require '../../models/TeamModel'
Handler    = require '../../framework/Handler'

class CreateTeamHandler extends Handler

  @route 'post /{organizationId}/teams'
  @demand ['requester is organization member']

  constructor: (@database) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {name} = request.payload

    team = new Team {name, organization}
    organization.addTeam(team)
    
    @database.create team, (err) =>
      return reply err if err?
      @database.update organization, (err) =>
        return reply err if err?
        model = new TeamModel(request.baseUrl, team)
        reply(model)#.location(model.uri)

module.exports = CreateTeamHandler
