Model = require 'http/framework/Model'

class MilestoneModel extends Model

  @describes: 'Milestone'
  @getUri: (id, request) -> "#{request.scope.organization.id}/milestones/#{id}"

  load: (milestone) ->
    @name = milestone.name
    @deadline = milestone.deadline
    @goal = @ref('goal', milestone.goal)
    @organization = @ref('organization', milestone.organization)

module.exports = MilestoneModel
