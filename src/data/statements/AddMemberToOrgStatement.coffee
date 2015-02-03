r               = require 'rethinkdb'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/framework/statements/UpdateStatement'

class AddMemberToOrgStatement extends UpdateStatement

  constructor: (orgid, userid) ->
    patch = {members: r.row('members').setInsert(userid)}
    super(Org, orgid, patch)

module.exports = AddMemberToOrgStatement
