Model = require '../framework/Model'

class UserModel extends Model

  constructor: (user) ->
    super(user.id)
    @username = user.username

module.exports = UserModel
