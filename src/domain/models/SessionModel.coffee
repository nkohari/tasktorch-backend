Model = require 'domain/framework/Model'

class SessionModel extends Model

  constructor: (session) ->
    super(session)
    @user = session.user

module.exports = SessionModel
