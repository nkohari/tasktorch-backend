PasswordChangedEvent = require 'events/users/PasswordChangedEvent'
User                 = require '../entities/User'
Service              = require '../framework/Service'

class UserService extends Service

  @type User

  constructor: (database, eventBus, @log, @passwordHasher) ->
    super(database, eventBus)

  changePassword: (user, newPassword, callback) ->
    user.password = @passwordHasher.hash(newPassword)
    event = new PasswordChangedEvent(user)
    @update user, (err) =>
      return callback(err) if err?
      @publish(event)
      callback()

module.exports = UserService
