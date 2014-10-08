Model = require '../framework/Model'

class TypeModel extends Model

  constructor: (baseUrl, type) ->
    super(type.id)
    @name = type.name
    @organization = type.organization
    @steps = type.steps
    @uri = "#{baseUrl}/#{@organization.id}/kinds/#{@id}"

module.exports = TypeModel
