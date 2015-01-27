Model = require 'domain/Model'

class MilestoneModel extends Model

  constructor: (milestone) ->
    super(milestone)
    @name     = milestone.name
    @deadline = milestone.deadline
    @goal     = milestone.goal
    @org      = milestone.org

module.exports = MilestoneModel
