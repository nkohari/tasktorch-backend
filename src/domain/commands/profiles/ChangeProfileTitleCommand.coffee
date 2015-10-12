Command                = require 'domain/framework/Command'
Profile                = require 'data/documents/Profile'
UpdateByIndexStatement = require 'data/statements/UpdateByIndexStatement'

class ChangeProfileTitleCommand extends Command

  constructor: (@user, @org, @title) ->

  execute: (conn, callback) ->
    statement = new UpdateByIndexStatement(Profile, {'user-org': [@user.id, @org.id]}, {@title})
    conn.execute statement, (err, profile) =>
      return callback(err) if err?
      callback(null, profile)

module.exports = ChangeProfileTitleCommand
