Precondition = require 'http/framework/Precondition'
QueryOptions = require 'http/framework/QueryOptions'

class ResolveQueryOptions extends Precondition

  assign: 'options'

  execute: (request, reply) ->
    reply new QueryOptions(request)

module.exports = ResolveQueryOptions
