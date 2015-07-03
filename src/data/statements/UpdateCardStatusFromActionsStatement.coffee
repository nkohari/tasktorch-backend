r               = require 'rethinkdb'
Action          = require 'data/documents/Action'
Card            = require 'data/documents/Card'
ActionStatus    = require 'data/enums/ActionStatus'
CardStatus      = require 'data/enums/CardStatus'
UpdateStatement = require 'data/statements/UpdateStatement'

# TODO: This is our only non-atomic update. It'd be great to remove this eventually.

class UpdateCardStatusFromActionsStatement extends UpdateStatement

  constructor: (cardid) ->

    arg = r.table(Action.getSchema().table)
      .getAll(cardid, {index: 'card'})
      .map((action) -> action('status'))
      .distinct()
      .do((statuses) ->
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
      )

    super(Card, cardid, {status: arg}, {nonAtomic: true})

module.exports = UpdateCardStatusFromActionsStatement
