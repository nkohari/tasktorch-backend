Precondition = require 'apps/api/framework/Precondition'
QueryOptions = require 'apps/api/framework/QueryOptions'

class ResolveQueryOptions extends Precondition

  assign: 'options'

  execute: (request, reply) ->
    reply new QueryOptions(request)

module.exports = ResolveQueryOptions
