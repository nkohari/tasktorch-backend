aws = require 'aws-sdk'

class Sender

  constructor: (@log, @config) ->
    @ses = new aws.SES {
      region:     @config.aws.region
      apiVersion: @config.aws.apiVersion
    }

  send: (email, callback) ->

    params = {
      Source: email.from
      Destination:
        ToAddresses: email.to
      Message:
        Subject: {Data: email.subject, Charset: 'utf8'}
        Body:
          Html: {Data: email.html, Charset: 'utf8'}
          Text: {Data: email.text, Charset: 'utf8'}
    }

    params.Destination.CcAddresses  = email.cc      if email.cc?
    params.Destination.BccAddresses = email.bcc     if email.bcc?
    params.ReplyToAddresses         = email.replyTo if email.replyTo?

    @ses.sendEmail params, (err, response) =>
      return callback(err) if err?
      callback()

module.exports = Sender
