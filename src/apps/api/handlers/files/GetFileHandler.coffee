Handler      = require 'apps/api/framework/Handler'
GetFileQuery = require 'data/queries/files/GetFileQuery'

class GetFileHandler extends Handler

  @route 'get /{orgid}/files/{fileid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {fileid}       = request.params

    query = new GetFileQuery(fileid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.file?
      return reply @error.notFound() unless result.file.org == org.id
      reply @response(result)

module.exports = GetFileHandler
