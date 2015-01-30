Model = require 'domain/framework/Model'

class OrgModel extends Model

  constructor: (org) ->
    super(org)
    @name    = org.name
    @members = org.members

module.exports = OrgModel
