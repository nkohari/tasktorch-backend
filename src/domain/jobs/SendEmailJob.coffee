Job = require 'domain/framework/Job'

class SendEmailJob extends Job

  constructor: (@template, options = {}, @params) ->
    super()
    {@to, @cc, @bcc} = options

module.exports = SendEmailJob
