r               = require 'rethinkdb'
Kind            = require 'data/documents/Kind'
UpdateStatement = require 'data/statements/UpdateStatement'

class IncrementKindNumberStatement extends UpdateStatement

  constructor: (kindid) ->
    patch = {nextNumber: r.row('nextNumber').add(1)}
    super(Kind, kindid, patch)

module.exports = IncrementKindNumberStatement
