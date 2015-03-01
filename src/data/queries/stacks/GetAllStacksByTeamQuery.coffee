Stack              = require 'data/documents/Stack'
GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'

class GetAllStacksByTeamQuery extends GetAllByIndexQuery

  constructor: (teamid, options) ->
    super(Stack, {team: teamid}, options)

module.exports = GetAllStacksByTeamQuery
