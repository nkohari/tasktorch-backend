_         = require 'lodash'
r         = require 'rethinkdb'
Stack     = require 'data/schemas/Stack'
StackType = require 'data/enums/StackType'
Query     = require 'data/framework/queries/Query'

class GetInboxByTeamQuery extends Query

  constructor: (organizationId, teamId, options) ->
    super(Stack, _.extend({firstResult: true}, options))
    @rql = r.table(Stack.table).getAll(teamId, {index: 'team'})
      .filter({organization: organizationId, type: StackType.Inbox})
      .limit(1)

module.exports = GetInboxByTeamQuery
