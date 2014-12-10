_         = require 'lodash'
r         = require 'rethinkdb'
Stack     = require 'data/schemas/Stack'
StackType = require 'data/enums/StackType'
Query     = require 'data/framework/queries/Query'

class GetInboxByTeamQuery extends Query

  constructor: (teamId, options) ->
    super(Stack, options)
    @rql = r.table(Stack.table).getAll(teamId, {index: 'team'})
      .filter({type: StackType.Inbox})
      .limit(1)
      .coerceTo('array').do (result) ->
        r.branch(result.isEmpty(), null, result.nth(0))

module.exports = GetInboxByTeamQuery
