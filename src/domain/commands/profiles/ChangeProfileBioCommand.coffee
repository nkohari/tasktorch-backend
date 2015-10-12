Command                = require 'domain/framework/Command'
Profile                = require 'data/documents/Profile'
UpdateByIndexStatement = require 'data/statements/UpdateByIndexStatement'

class ChangeProfileBioCommand extends Command

  constructor: (@user, @org, @bio) ->

  execute: (conn, callback) ->
    statement = new UpdateByIndexStatement(Profile, {'user-org': [@user.id, @org.id]}, {@bio})
    conn.execute statement, (err, profile) =>
      return callback(err) if err?
      callback(null, profile)

module.exports = ChangeProfileBioCommand
