uuid    = require 'node-uuid'
encoder = require 'int-encoder'

class KeyGenerator

  constructor: ->
    encoder.alphabet('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

  generate: ->
    buf = new Buffer(16)
    uuid.v4(null, buf)
    return encoder.encode(buf.toString('hex'), 16)

module.exports = KeyGenerator
