_            = require 'lodash'
r            = require 'rethinkdb'
ActionStatus = require 'data/enums/ActionStatus'
Action       = require 'data/documents/Action'
Card         = require 'data/documents/Card'
Query        = require 'data/framework/queries/Query'

# TODO: This cheats a bit by taking the kindid as a parameter. I know we'll have it in the
# ListCardsByStageHandler, which is currently the only consumer of this query. If needed,
# we can query the kindid from the Stage document, it's just unnecessary if we already know it.

class GetAllCardsByStageQuery extends Query

  constructor: (stageid, kindid, options) ->
    super(Card, options)

    emptyLookup = _.object _.map ActionStatus, (value) -> [value, []]

    @rql = r.table(Card.getSchema().table).getAll(kindid, {index: 'kind'})
      .filter((card) ->
        r.table(Action.getSchema().table).getAll(card('id'), {index: 'card'}).coerceTo('array')
        .do (actions) ->
          r.branch(
            actions.isEmpty(),
            false,
            r.expr(emptyLookup).merge(
              actions.group('status').ungroup()
              .map (grouping) -> r.object(grouping('group'), grouping('reduction'))
              .reduce (left, right) -> left.merge(right)
            ).do (lookup) ->
              r.branch(
                r.and(lookup(ActionStatus.InProgress).isEmpty(), lookup(ActionStatus.Warning).isEmpty()),
                lookup(ActionStatus.Complete).max((action) -> action('completed'))('stage').eq(stageid)
                lookup(ActionStatus.InProgress)('stage').setUnion(lookup(ActionStatus.Warning)('stage')).contains(stageid)
              )
          )
      ).coerceTo('array')


module.exports = GetAllCardsByStageQuery
