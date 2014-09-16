class CardResource

  create: (request, reply) ->
    reply('create')

  get: (request, reply) ->
    reply('get')

  pass: (request, reply) ->
    reply('pass')

  delete: (request, reply) ->
    reply('delete')

module.exports = CardResource
