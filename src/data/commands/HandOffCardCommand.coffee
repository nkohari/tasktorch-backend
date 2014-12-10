async    = require 'async'
r        = require 'rethinkdb'
Document = require 'data/framework/Document'
Command  = require 'data/framework/commands/Command'
Card     = require 'data/schemas/Card'
Stack    = require 'data/schemas/Stack'

class HandOffCardCommand extends Command

  constructor: (@cardId, @stackId, @ownerId) ->
    super()

  execute: (conn, callback) ->

    removeFromOldStack = r.table(Stack.table)
      .get(r.table(Card.table).get(@cardId)('stack'))
      .update({cards: r.row('cards').difference([@cardId])}, {returnChanges: true})

    insertIntoNewStack = r.table(Stack.table)
      .get(@stackId)
      .update({cards: r.row('cards').append(@cardId)}, {returnChanges: true})

    updateCard = r.table(Card.table)
      .get(@cardId)
      .update({stack: @stackId, owner: @ownerId}, {returnChanges: true})

    statements = [
      removeFromOldStack
      insertIntoNewStack
      updateCard
    ]

    async.map statements, ((rql, next) -> rql.run(conn, next)), (err, results) ->
      return callback(err) if err?
      oldStack = new Document(Stack, results[0].changes[0].new_val)
      newStack = new Document(Stack, results[1].changes[0].new_val)
      card     = new Document(Card,  results[2].changes[0].new_val)
      callback null, {card, oldStack, newStack}

module.exports = HandOffCardCommand
