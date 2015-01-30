Team            = require 'data/documents/Team'
CreateStatement = require 'data/framework/statements/CreateStatement'

class CreateTeamStatement extends CreateStatement

  constructor: (data) ->
    super(Team, data)

module.exports = CreateTeamStatement
