nodeuuid = require 'node-uuid'
encoder  = require 'int-encoder'

encoder.alphabet('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

module.exports = uuid = ->
  buf = new Buffer(16)
  nodeuuid.v4(null, buf)
  return encoder.encode(buf.toString('hex'), 16)
