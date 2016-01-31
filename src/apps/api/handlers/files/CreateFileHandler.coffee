crypto               = require 'crypto'
fs                   = require 'fs'
zlib                 = require 'zlib'
uuid                 = require 'common/util/uuid'
Handler              = require 'apps/api/framework/Handler'
File                 = require 'data/documents/File'
FileStatus           = require 'data/enums/FileStatus'
AddFileToCardCommand = require 'domain/commands/files/AddFileToCardCommand'
CreateFileCommand    = require 'domain/commands/files/CreateFileCommand'

MAX_UPLOAD_SIZE = 100*1024*1024 # 100 MB
MAX_UPLOAD_TIME = 5*60*1000     # 5 minutes

class CreateFileHandler extends Handler

  @route 'post /{orgid}/files'

  @config
    payload:
      output: 'file'
      maxBytes: MAX_UPLOAD_SIZE
      timeout: MAX_UPLOAD_TIME
    timeout:
      socket: false

  @ensure
    payload:
      file: @mustBe.any().required()
      card: @mustBe.string()

  @before [
    'resolve org'
    'resolve optional card argument'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure requester can access org'
  ]

  constructor: (aws, @log, @config, @thumbnailer, @database, @processor) ->
    @s3 = aws.createS3Client()

  handle: (request, reply) ->

    {org, card} = request.pre
    {user}      = request.auth.credentials
    incoming    = request.payload.file
    type        = incoming.headers['content-type']

    file = new File {
      id:   uuid()
      org:  org.id
      name: incoming.filename
      size: incoming.bytes
      type: type
      key:  crypto.randomBytes(16).toString('hex')
    }

    @tryToGenerateThumbnail file, incoming.path, (err, hasThumbnail) =>
      return reply err if err?
      file.hasThumbnail = hasThumbnail
      @upload file, incoming.path, (err) =>
        return reply err if err?
        command = new CreateFileCommand(user, file)
        @processor.execute command, (err, file) =>
          return reply err if err?
          @addFileToCardIfNecessary user, file, card, (err) =>
            return reply err if err?
            reply @response(file)

  upload: (file, tempPath, callback) ->
    @log.debug "Uploading file from #{tempPath}"
    @s3.upload {
      Bucket: @config.aws.buckets.files
      Key: "#{file.org}/#{file.id}"
      Body: fs.createReadStream(tempPath).pipe(zlib.createGzip())
      ContentEncoding: 'gzip'
      ContentType: file.type
      SSECustomerAlgorithm: 'AES256'
      SSECustomerKey: file.key
    }, (err) =>
      fs.unlink tempPath, (err) =>
        @log.warn("Error deleting temporary file: #{err}") if err?
        callback()

  tryToGenerateThumbnail: (file, tempPath, callback) ->
    @thumbnailer.generate tempPath, 300, (err, thumbnailPath) =>
      return callback(err) if err?
      return callback(null, false) unless thumbnailPath?
      @log.debug "Uploading thumbnail from #{thumbnailPath}"
      @s3.upload {
        Bucket: @config.aws.buckets.files
        Key: "#{file.org}/#{file.id}-t"
        Body: fs.createReadStream(thumbnailPath).pipe(zlib.createGzip())
        ContentEncoding: 'gzip'
        ContentType: 'image/jpeg'
        SSECustomerAlgorithm: 'AES256'
        SSECustomerKey: file.key
      }, (err) =>
        return callback(err) if err?
        fs.unlink thumbnailPath, (err) =>
          @log.warn("Error deleting temporary file: #{err}") if err?
          callback(null, true)

  addFileToCardIfNecessary: (user, file, card, callback) ->
    return callback() unless card?
    command = new AddFileToCardCommand(user, file, card)
    @processor.execute(command, callback)

module.exports = CreateFileHandler
