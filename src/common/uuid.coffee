uuid    = require 'node-uuid'
encoder = require 'int-encoder'

encoder.alphabet('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

exports.generate = ->
  buf = new Buffer(16)
  uuid.v4(null, buf)
  return encoder.encode(buf.toString('hex'), 16)
