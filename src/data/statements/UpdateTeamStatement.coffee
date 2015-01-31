Team            = require 'data/documents/Team'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class UpdateTeamStatement extends UpdateStatement

  constructor: (id, diff) ->
    super(Team, id, diff)

module.exports = UpdateTeamStatement