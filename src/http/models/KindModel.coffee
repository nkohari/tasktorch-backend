Model = require 'http/framework/Model'

class KindModel extends Model

  @describes: 'Kind'
  @getUri: (id, request) -> "#{request.scope.organization.id}/kinds/#{id}"

  load: (kind) ->
    @name = kind.name
    @color = kind.color
    @organization = @one('organization', kind.organization)

module.exports = KindModel
