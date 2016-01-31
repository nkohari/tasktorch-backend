stream  = require 'stream'
zlib    = require 'zlib'
_       = require 'lodash'
Handler = require 'apps/api/framework/Handler'

class GetFileThumbnailHandler extends Handler

  @route 'get /{orgid}/files/{fileid}/thumbnail'

  @before [
    'resolve org'
    'resolve file'
    'ensure org has active subscription'
    'ensure file belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@log, @config, aws) ->
    @s3 = aws.createS3Client()

  handle: (request, reply) ->

    {user}      = request.auth.credentials
    {org, file} = request.pre

    unless file.hasThumbnail
      return reply().type('image/jpeg')

    params = {
      Bucket: @config.aws.buckets.files
      Key: "#{org.id}/#{file.id}-t"
      SSECustomerAlgorithm: 'AES256'
      SSECustomerKey: file.key
    }

    stream = @s3.getObject(params).createReadStream().pipe(zlib.createGunzip())

    reply(stream)
    .type('image/jpeg')
    .header('Last-Modified', file.updated.toUTCString())

module.exports = GetFileThumbnailHandler
