r               = require 'rethinkdb'
Kind            = require 'data/documents/Kind'
UpdateStatement = require 'data/statements/UpdateStatement'

class MoveStageStatement extends UpdateStatement

  constructor: (kindid, stageid, position) ->

    arg = r.row('stages').setDifference([stageid])

    if position is 'prepend'
      arg = arg.prepend(stageid)
    else if position is 'append'
      arg = arg.append(stageid)
    else
      arg = arg.insertAt(position, stageid)

    super(Kind, kindid, {stages: arg})

module.exports = MoveStageStatement
