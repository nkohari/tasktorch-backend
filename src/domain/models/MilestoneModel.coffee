Model = require 'domain/Model'

class MilestoneModel extends Model

  constructor: (milestone) ->
    super(milestone)
    @name         = milestone.name
    @deadline     = milestone.deadline
    @goal         = milestone.goal
    @organization = milestone.organization

module.exports = MilestoneModel
