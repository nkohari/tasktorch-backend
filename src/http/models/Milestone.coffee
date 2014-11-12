Model = require 'http/framework/Model'

class MilestoneModel extends Model

  @describes: 'Milestone'
  @getUri: (id, request) -> "#{request.scope.organization.id}/milestones/#{id}"

  load: (milestone) ->
    @name = milestone.name
    @deadline = milestone.deadline
    @goal = @one('goal', milestone.goal)
    @organization = @one('organization', milestone.organization)

module.exports = MilestoneModel
