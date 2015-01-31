scrypt = require 'scrypt'

class PasswordHasher

  constructor: (@config) ->
    maxTime = @config.security.scrypt.maxTime / 1000
    @params = scrypt.params(maxTime)

  hash: (plaintext) ->
    return "" unless plaintext?.length > 0
    buf = scrypt.hash(new Buffer(plaintext, 'utf8'), @params)
    return buf.toString('base64')

  verify: (hash, attempt) ->
    scrypt.verify(new Buffer(hash, 'base64'), new Buffer(attempt, 'utf8'))

module.exports = PasswordHasher
