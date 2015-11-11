Model = require 'domain/framework/Model'

class OrgModel extends Model

  constructor: (org) ->
    super(org)
    @name    = org.name
    @email   = org.email
    @account = org.account

module.exports = OrgModel
