Model = require 'domain/Model'

class KindModel extends Model

  constructor: (kind) ->
    super(kind)
    @name   = kind.name
    @color  = kind.color
    @org    = kind.org
    @stages = kind.stages

module.exports = KindModel
