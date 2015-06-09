Model = require 'domain/framework/Model'

class GoalModel extends Model

  constructor: (goal) ->
    super(goal)
    @name  = goal.name
    @org   = goal.org

module.exports = GoalModel
