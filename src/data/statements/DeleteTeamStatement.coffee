Team            = require 'data/documents/Team'
DeleteStatement = require 'data/framework/statements/DeleteStatement'

class DeleteTeamStatement extends DeleteStatement

  constructor: (id) ->
    super(Team, id)

module.exports = DeleteTeamStatement
