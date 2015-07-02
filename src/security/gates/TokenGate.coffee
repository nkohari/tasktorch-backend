_    = require 'lodash'
Gate = require 'security/framework/Gate'

class TokenGate extends Gate

  guards: 'Token'

  getAccessList: (token, callback) ->
    callback null, [token.creator]

module.exports = TokenGate
