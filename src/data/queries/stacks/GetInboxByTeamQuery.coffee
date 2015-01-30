_         = require 'lodash'
r         = require 'rethinkdb'
Stack     = require 'data/documents/Stack'
Query     = require 'data/framework/queries/Query'
StackType = require 'data/enums/StackType'

class GetInboxByTeamQuery extends Query

  constructor: (teamid, options) ->
    super(Stack, options)
    @rql = r.table(@schema.table).getAll(teamid, {index: 'team'})
      .filter({type: StackType.Inbox})
      .limit(1)
      .coerceTo('array').do (result) ->
        r.branch(result.isEmpty(), null, result.nth(0))

module.exports = GetInboxByTeamQuery
