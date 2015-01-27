Document = require './Document'

class Team extends Document

  constructor: (data) ->
    super(data)
    @organization = data.organization
    @name         = data.name
    @stacks       = data.stacks  ? []
    @members      = data.members ? []
    @leaders      = data.leaders ? []

module.exports = Team
