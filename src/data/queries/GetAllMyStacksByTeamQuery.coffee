r     = require 'rethinkdb'
Query = require '../framework/Query'

class GetAllMyStacksByTeamQuery extends Query

  constructor: (userId, options) ->
    super(options)
    @rql = r.table('teams').getAll(userId, {index: 'members'}).merge (team) ->
      {stacks: r.table('stacks').getAll(team('id'), {index: 'team'}).coerceTo('array')}

module.exports = GetAllMyStacksByTeamQuery
