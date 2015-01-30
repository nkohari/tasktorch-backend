Model = require 'domain/framework/Model'

class GoalModel extends Model

  constructor: (goal) ->
    super(goal)
    @name     = goal.name
    @deadline = goal.deadline
    @org      = goal.org

module.exports = GoalModel
