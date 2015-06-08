r                 = require 'rethinkdb'
GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Card              = require 'data/documents/Card'
Goal              = require 'data/documents/Goal'

class GetAllCardsByGoalQuery extends GetAllByListQuery

  constructor: (goalid, options) ->
    super(Card, Goal, goalid, 'cards', options)

module.exports = GetAllCardsByGoalQuery
