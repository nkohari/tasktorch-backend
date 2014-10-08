Model = require '../framework/Model'

class UserModel extends Model

  constructor: (user) ->
    super(user.id)
    @username = user.username
    @name = user.name
    @emails = user.emails

module.exports = UserModel
