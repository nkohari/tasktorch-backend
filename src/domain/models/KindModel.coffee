Model = require 'domain/framework/Model'

class KindModel extends Model

  constructor: (kind) ->
    super(kind)
    @name       = kind.name
    @color      = kind.color
    @nextNumber = kind.nextNumber
    @org        = kind.org
    @stages     = kind.stages

module.exports = KindModel
