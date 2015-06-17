_                            = require 'lodash'
uuid                         = require 'common/util/uuid'
Command                      = require 'domain/framework/Command'
Action                       = require 'data/documents/Action'
Checklist                    = require 'data/documents/Checklist'
CardCreatedNote              = require 'data/documents/notes/CardCreatedNote'
AddCardToStackStatement      = require 'data/statements/AddCardToStackStatement'
BulkCreateStatement          = require 'data/statements/BulkCreateStatement'
CreateStatement              = require 'data/statements/CreateStatement'
IncrementKindNumberStatement = require 'data/statements/IncrementKindNumberStatement'

class CreateCardCommand extends Command

  constructor: (@user, @card, @kind, @stages) ->

  execute: (conn, callback) ->
    statement = new IncrementKindNumberStatement(@kind.id)
    conn.execute statement, (err, kind) =>
      return callback(err) if err?
      @card.number = kind.nextNumber
      statement = new CreateStatement(@card)
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        {checklists, actions} = @buildChecklists(card)
        statement = new BulkCreateStatement(Action, actions)
        conn.execute statement, (err, actions) =>
          return callback(err) if err?
          statement = new BulkCreateStatement(Checklist, checklists)
          conn.execute statement, (err, checklists) =>
            return callback(err) if err?
            statement = new AddCardToStackStatement(card.stack, card.id, 'append')
            conn.execute statement, (err, stack) =>
              return callback(err) if err?
              note = CardCreatedNote.create(@user, card)
              statement = new CreateStatement(note)
              conn.execute statement, (err) =>
                return callback(err) if err?
                callback(null, card)

  buildChecklists: (card) ->

    checklists = _.map @stages, (stage) =>
      new Checklist {
        id:      uuid()
        org:     card.org
        card:    card.id
        stage:   stage.id
        actions: []
      }

    lookup  = _.indexBy(checklists, 'stage')
    actions = []

    _.each @stages, (stage) =>
      checklist = lookup[stage.id]
      _.each stage.defaultActions, (data) =>
        action = new Action {
          id:        uuid()
          org:       card.org
          card:      card.id
          stage:     stage.id
          checklist: checklist.id
          text:      data.text
        }
        checklist.actions.push(action.id)
        actions.push(action)

    return {checklists, actions}

module.exports = CreateCardCommand
