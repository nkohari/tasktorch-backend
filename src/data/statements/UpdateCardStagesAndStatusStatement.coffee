_               = require 'lodash'
r               = require 'rethinkdb'
Action          = require 'data/documents/Action'
Card            = require 'data/documents/Card'
Kind            = require 'data/documents/Kind'
ActionStatus    = require 'data/enums/ActionStatus'
CardStatus      = require 'data/enums/CardStatus'
UpdateStatement = require 'data/statements/UpdateStatement'

class UpdateCardStagesAndStatusStatement extends UpdateStatement

  constructor: (cardid) ->

    patch = (card) => {
      status:  @getStatusStatement(cardid)
      stages:  @getStagesStatement(card)
      version: card('version').add(1)
      updated: r.now()
    }

    super(Card, cardid, patch, {nonAtomic: true})

  getStagesStatement: (card) ->

    r.branch(
      r.or(card('status').eq(CardStatus.Complete), card('status').eq(CardStatus.Deleted)),
      [],
      r.expr({NotStarted: [], InProgress: [], Complete: [], Warning: []}).merge(
        r.table(Action.getSchema().table).getAll(card('id'), {index: 'card'})
        .filter (action) -> action('status').eq(ActionStatus.Deleted).not()
        .group('status')
        .ungroup()
        .map (grouping) -> r.object(grouping('group'), grouping('reduction'))
        .reduce (left, right) -> left.merge(right)
      ).do (lookup) ->
        r.branch(
          r.and(lookup(ActionStatus.InProgress).isEmpty(), lookup(ActionStatus.Complete).isEmpty(), lookup(ActionStatus.Warning).isEmpty()),
          [],
          r.branch(
            r.or(lookup(ActionStatus.InProgress).isEmpty().not(), lookup(ActionStatus.Warning).isEmpty().not()),
            lookup(ActionStatus.InProgress)('stage').setUnion(lookup(ActionStatus.Warning)('stage')),
            r.table(Kind.getSchema().table).get(card('kind'))('stages')
            .filter (stageid) -> lookup(ActionStatus.NotStarted)('stage').contains(stageid)
            .do (stages) ->
              r.branch(stages.isEmpty(), [], [stages.nth(0)]);
          )
        )
    )    

  getStatusStatement: (cardid) ->

    r.table(Action.getSchema().table)
      .getAll(cardid, {index: 'card'})
      .map (action) -> action('status')
      .distinct()
      .do (statuses) ->
        r.branch(
          statuses.contains(ActionStatus.Warning),
          CardStatus.Warning,
          r.branch(
            statuses.contains(ActionStatus.InProgress),
            CardStatus.InProgress,
            r.branch(
              statuses.contains(ActionStatus.Complete),
              CardStatus.Idle,
              CardStatus.NotStarted
            )
          )
        )

module.exports = UpdateCardStagesAndStatusStatement
