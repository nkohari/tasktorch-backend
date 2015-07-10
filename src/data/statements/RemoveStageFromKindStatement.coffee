r               = require 'rethinkdb'
Kind            = require 'data/documents/Kind'
UpdateStatement = require 'data/statements/UpdateStatement'

class RemoveStageFromKindStatement extends UpdateStatement

  constructor: (kindid, stageid) ->
    patch = {stages: r.row('stages').setDifference([stageid])}
    super(Kind, kindid, patch)

module.exports = RemoveStageFromKindStatement
