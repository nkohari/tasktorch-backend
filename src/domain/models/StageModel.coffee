Model = require 'domain/framework/Model'

class StageModel extends Model

  constructor: (stage) ->
    super(stage)
    @name           = stage.name
    @defaultActions = stage.defaultActions
    @kind           = stage.kind

module.exports = StageModel
