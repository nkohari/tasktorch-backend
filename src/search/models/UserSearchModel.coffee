class UserSearchModel

  @type: 'user'

  constructor: (user) ->
    @id       = user.id
    @name     = user.name
    @username = user.username
    @emails   = user.emails

module.exports = UserSearchModel
