Model = require 'http/framework/Model'

class HandoffModel extends Model

  constructor: (handoff) ->
    super(handoff)
    @timestamp = handoff.timestamp
    @message   = handoff.message
    @sender    = handoff.sender
    @user      = handoff.user if handoff.user?
    @team      = handoff.team if handoff.team?

module.exports = HandoffModel
