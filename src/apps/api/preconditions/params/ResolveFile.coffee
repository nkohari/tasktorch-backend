Precondition = require 'apps/api/framework/Precondition'
GetFileQuery = require 'data/queries/files/GetFileQuery'

class ResolveFile extends Precondition

  assign: 'file'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetFileQuery(request.params.fileid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.file?
      reply(result.file)

module.exports = ResolveFile
