Model = require 'http/framework/Model'

class StageModel extends Model

  @describes: 'Stage'
  @getUri: (id, request) -> "#{request.scope.organization.id}/stages/#{id}"

  load: (stage) ->
    @name = stage.name
    @kind = @one('kind', stage.kind)

module.exports = StageModel
