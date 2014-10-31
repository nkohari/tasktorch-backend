Model = require 'http/framework/Model'

class TypeModel extends Model

  @describes: 'Type'
  @getUri: (id, request) -> "#{request.scope.organization.id}/types/#{id}"

  load: (type) ->
    @name = type.name
    @organization = @ref('organization', type.organization)
    @steps = type.steps #TODO

module.exports = TypeModel
