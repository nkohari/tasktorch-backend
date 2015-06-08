GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Goal               = require 'data/documents/Goal'

class GetAllGoalsByCardQuery extends GetAllByIndexQuery

  constructor: (cardid, options) ->
    super(Goal, {cards: cardid}, options)

module.exports = GetAllGoalsByCardQuery
