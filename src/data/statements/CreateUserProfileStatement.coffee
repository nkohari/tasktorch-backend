_               = require 'lodash'
Profile         = require 'data/documents/Profile'
CreateStatement = require 'data/statements/CreateStatement'

class CreateUserProfileStatement extends CreateStatement

  constructor: (userid, orgid) ->
    profile = new Profile {org: orgid, user: userid}
    super(profile)

module.exports = CreateUserProfileStatement
