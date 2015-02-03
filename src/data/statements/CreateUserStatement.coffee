User            = require 'data/documents/User'
CreateStatement = require 'data/framework/statements/CreateStatement'

class CreateUserStatement extends CreateStatement

  constructor: (data) ->
    super(User, data)

module.exports = CreateUserStatement
