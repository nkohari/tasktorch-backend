crypto = require 'crypto'
Model  = require 'domain/framework/Model'

class UserModel extends Model

  constructor: (user) ->
    super(user)
    @username  = user.username
    @name      = user.name
    # TODO: Make this configurable instead of always being the first email address
    @avatarUrl = @getAvatarUrl(user.emails[0])

  getAvatarUrl: (email) ->
    hash = crypto.createHash('md5').update(email).digest('hex')
    return "https://www.gravatar.com/avatar/#{hash}"

module.exports = UserModel
