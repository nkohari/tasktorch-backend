Model = require 'domain/Model'

class GoalModel extends Model

  constructor: (goal) ->
    super(goal)
    @name         = goal.name
    @deadline     = goal.deadline
    @organization = goal.organization

module.exports = GoalModel
