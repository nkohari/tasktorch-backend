r               = require 'rethinkdb'
Kind            = require 'data/documents/Kind'
UpdateStatement = require 'data/statements/UpdateStatement'

class AddStageToKindStatement extends UpdateStatement

  constructor: (kindid, stageid, position = 'append') ->

    if position is 'prepend'
      arg = r.row('stages').prepend(stageid)
    else if position is 'append'
      arg = r.row('stages').append(stageid)
    else
      arg = r.row('stages').insertAt(position, stageid)

    super(Kind, kindid, {stages: arg})

module.exports = AddStageToKindStatement
