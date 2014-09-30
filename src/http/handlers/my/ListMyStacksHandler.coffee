async = require 'async'
{Stack} = require 'data/entities'
GetAllByQuery = require 'data/queries/GetAllByQuery'
GetAllMyStacksByTeamQuery = require 'data/queries/GetAllMyStacksByTeamQuery'
Handler = require '../../framework/Handler'

class ListMyStacksHandler extends Handler

  @route 'get /my/stacks'

  constructor: (@database) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    async.parallel [
      (cb) => @database.execute(new GetAllByQuery(Stack, {owner: user.id}), cb)
      (cb) => @database.execute(new GetAllMyStacksByTeamQuery(user.id), cb)
    ], (err, [userStacks, teamStacks]) =>
      return reply err if err?
      reply {
        user: userStacks
        teams: teamStacks
      }

module.exports = ListMyStacksHandler
