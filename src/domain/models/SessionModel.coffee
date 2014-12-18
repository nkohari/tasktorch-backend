Model = require 'domain/Model'

class SessionModel extends Model

  constructor: (session) ->
    super(session)
    user = session.user

module.exports = SessionModel
