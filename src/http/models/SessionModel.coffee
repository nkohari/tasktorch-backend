Model = require '../framework/Model'

class SessionModel extends Model

  constructor: (session) ->
    super(session.id)
    @user = session.user

module.exports = SessionModel
