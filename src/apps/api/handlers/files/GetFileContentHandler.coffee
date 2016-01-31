stream  = require 'stream'
zlib    = require 'zlib'
_       = require 'lodash'
Handler = require 'apps/api/framework/Handler'

class GetFileContentHandler extends Handler

  @route 'get /{orgid}/files/{fileid}/content'

  @ensure
    query:
      download: @mustBe.boolean().default(false)

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
    {download}  = request.query

    params = {
      Bucket: @config.aws.buckets.files
      Key: "#{org.id}/#{file.id}"
      SSECustomerAlgorithm: 'AES256'
      SSECustomerKey: file.key
    }

    stream = @s3.getObject(params).createReadStream().pipe(zlib.createGunzip())
    
    response = reply(stream)
    .type(file.type)
    .bytes(file.size)
    .header('Last-Modified', file.updated.toUTCString())

    if download
      response.header("Content-Disposition", "attachment; filename=#{file.name}")

module.exports = GetFileContentHandler
