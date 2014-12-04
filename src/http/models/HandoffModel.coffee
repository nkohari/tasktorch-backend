Model = require 'http/framework/Model'

class HandoffModel extends Model

  @describes: 'Handoff'
  @getUri: (id, request) -> "#{request.scope.organization.id}/handoffs/#{id}"

  load: (handoff) ->
    @timestamp = handoff.timestamp
    @message = handoff.message
    @sender = @one('sender', handoff.sender)
    @user = @one('user', handoff.user) if handoff.user?
    @team = @one('team', handoff.team) if handoff.team?

module.exports = HandoffModel
