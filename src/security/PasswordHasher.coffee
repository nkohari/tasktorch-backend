scrypt = require 'scrypt'

class PasswordHasher

  constructor: (@config) ->
    maxTime = @config.security.scrypt.maxTime / 1000
    @params = scrypt.paramsSync(maxTime)

  hash: (plaintext) ->
    return "" unless plaintext?.length > 0
    buf = scrypt.kdfSync(new Buffer(plaintext, 'utf8'), @params)
    return buf.toString('base64')

  verify: (hash, attempt) ->
    scrypt.verifyKdfSync(new Buffer(hash, 'base64'), new Buffer(attempt, 'utf8'))

module.exports = PasswordHasher
