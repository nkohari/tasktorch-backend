r                 = require 'rethinkdb'
GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Goal              = require 'data/documents/Goal'
Card              = require 'data/documents/Card'

class GetAllGoalsByCardQuery extends GetAllByListQuery

  constructor: (cardid, options) ->
    super(Goal, Card, cardid, 'goals', options)

module.exports = GetAllGoalsByCardQuery
