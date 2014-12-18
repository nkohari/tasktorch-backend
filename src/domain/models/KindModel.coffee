Model = require 'domain/Model'

class KindModel extends Model

  constructor: (kind) ->
    super(kind)
    @name         = kind.name
    @color        = kind.color
    @organization = kind.organization
    @stages       = kind.stages

module.exports = KindModel
