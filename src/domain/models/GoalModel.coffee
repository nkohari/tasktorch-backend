Model = require 'domain/framework/Model'

class GoalModel extends Model

  constructor: (goal) ->
    super(goal)
    @name        = goal.name
    @description = goal.description
    @timeframe   = goal.timeframe
    @org         = goal.org

module.exports = GoalModel
