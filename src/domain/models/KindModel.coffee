Model = require 'domain/framework/Model'

class KindModel extends Model

  constructor: (kind) ->
    super(kind)
    @name           = kind.name
    @color          = kind.color
    @description    = kind.description
    @nextNumber     = kind.nextNumber
    @defaultActions = kind.defaultActions
    @org            = kind.org
    @stages         = kind.stages

module.exports = KindModel
