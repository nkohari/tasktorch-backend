r               = require 'rethinkdb'
User            = require 'data/documents/User'
UpdateStatement = require 'data/statements/UpdateStatement'

class UpdateUserProfileFieldStatement extends UpdateStatement

  constructor: (userid, orgid, name, value) ->

    patch = {}
    patch[orgid] = {}
    patch[orgid][name] = value

    super(User, userid, {profile: patch})

module.exports = UpdateUserProfileFieldStatement
