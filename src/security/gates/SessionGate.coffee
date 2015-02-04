_    = require 'lodash'
Gate = require 'security/framework/Gate'

class SessionGate extends Gate

  guards: 'Session'

  getAccessList: (session, callback) ->
    callback null, [session.user]

module.exports = SessionGate
