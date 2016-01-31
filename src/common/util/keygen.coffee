crypto  = require 'crypto'
encoder = require 'int-encoder'

encoder.alphabet('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')

exports.generate = generate = (length) ->
  buf = crypto.randomBytes(length / 8)
  return encoder.encode(buf.toString('hex'), 16)

exports.hex = hex = (key) ->
  return encoder.decode(key, 16)
  
exports.prepare = prepare = (key) ->
  hex = encoder.decode(key, 16)
  md5 = crypto.createHash('md5').update(hex).digest('hex')
  {hex, md5}
