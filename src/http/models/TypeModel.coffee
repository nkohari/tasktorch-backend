Model = require '../framework/Model'

class TypeModel extends Model

  getUri: (type, request) ->
    "#{request.scope.organization.id}/types/#{type.id}"

  assignProperties: (type) ->
    @name = type.name
    @organization = @one('OrganizationModel', type.organization)
    @steps = type.steps #TODO

module.exports = TypeModel
