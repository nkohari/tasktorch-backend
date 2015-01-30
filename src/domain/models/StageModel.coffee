Model = require 'domain/framework/Model'

class StageModel extends Model

  constructor: (stage) ->
    super(stage)
    @name = stage.name
    @kind = stage.kind

module.exports = StageModel
