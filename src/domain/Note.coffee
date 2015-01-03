DocumentStatus = require 'data/DocumentStatus'

class Note

  constructor: (@type, @organization, @card, @user, @content = {}) ->
    @time = new Date()

module.exports = Note
