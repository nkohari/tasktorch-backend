Team            = require 'data/schemas/Team'
DeleteStatement = require 'data/framework/statements/DeleteStatement'

class DeleteTeamStatement extends DeleteStatement

  constructor: (id) ->
    super(Team, id)

module.exports = DeleteTeamStatement
