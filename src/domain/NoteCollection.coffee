_        = require 'lodash'
Note     = require './Note'
NoteType = require './NoteType'

class NoteCollection

  constructor: (@user) ->
    @_notes = []

  created: (card) ->
    @_add(NoteType.Created, card)

  changed: (field, card, previous) ->
    console.log {field, card, previous}
    @_add(NoteType.Changed, card, {field: field, from: previous[field], to: card[field]})

  passed: (card, stackId, ownerId) ->
    @_add(NoteType.Passed, card, {stack: stackId, owner: ownerId})

  completed: (card) ->
    @_add(NoteType.Completed, card)

  deleted: (card) ->
    @_add(NoteType.Completed, card)

  _add: (type, card, content) ->
    @_notes.push new Note(type, card.organization, card.id, @user.id, content)

  toArray: ->
    _.clone(@_notes)

module.exports = NoteCollection
