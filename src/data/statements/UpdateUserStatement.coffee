User            = require 'data/schemas/User'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class UpdateUserStatement extends UpdateStatement

  constructor: (id, diff) ->
    super(User, id, diff)

module.exports = UpdateUserStatement
