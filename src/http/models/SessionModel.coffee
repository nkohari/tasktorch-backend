Model = require 'http/framework/Model'

class SessionModel extends Model

  @describes: 'Session'
  @getUri: (id, request) -> "sessions/#{id}"

  load: (session) ->
    @user = @ref('user', session.user)

module.exports = SessionModel
