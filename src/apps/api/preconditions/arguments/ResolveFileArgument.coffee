Precondition = require 'apps/api/framework/Precondition'
GetFileQuery = require 'data/queries/files/GetFileQuery'

class ResolveFileArgument extends Precondition

  assign: 'file'

  constructor: (@database) ->

  execute: (request, reply) ->
    fileid = request.payload.file
    query = new GetFileQuery(fileid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such file #{fileid}") unless result.file?
      reply(result.file)

module.exports = ResolveFileArgument
