r                 = require 'rethinkdb'
GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Action            = require 'data/schemas/Action'
Card              = require 'data/schemas/Card'

class GetAllActionsByCardQuery extends GetAllByListQuery

  constructor: (cardId, options) ->
    super(Action, Card, cardId, 'actions', options)

module.exports = GetAllActionsByCardQuery
