Model = require 'http/framework/Model'

class GoalModel extends Model

  @describes: 'Goal'
  @getUri: (id, request) -> "#{request.scope.organization.id}/goals/#{id}"

  load: (goal) ->
    @name = goal.name
    @deadline = goal.deadline
    @organization = @ref('organization', goal.organization)

module.exports = GoalModel
