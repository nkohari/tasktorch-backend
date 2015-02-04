Org             = require 'data/documents/Org'
CreateStatement = require 'data/framework/statements/CreateStatement'

class CreateOrgStatement extends CreateStatement

  constructor: (data) ->
    super(Org, data)

module.exports = CreateOrgStatement
