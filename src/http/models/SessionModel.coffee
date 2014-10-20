Model = require '../framework/Model'

class SessionModel extends Model

  getUri: (session, request) ->
    "sessions/#{session.id}"

  assignProperties: (session) ->
    @user = @one('UserModel', session.user)

module.exports = SessionModel
