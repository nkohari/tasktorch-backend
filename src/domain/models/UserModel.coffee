crypto = require 'crypto'
Model  = require 'domain/framework/Model'

class UserModel extends Model

  constructor: (user) ->
    super(user)
    @username  = user.username
    @name      = user.name
    @email     = user.email
    @timezone  = user.timezone
    @flags     = user.flags
    @avatarUrl = @getAvatarUrl(user.email)

  getAvatarUrl: (email) ->
    hash = crypto.createHash('md5').update(email).digest('hex')
    return "https://www.gravatar.com/avatar/#{hash}?rating=g&d=identicon"

module.exports = UserModel
