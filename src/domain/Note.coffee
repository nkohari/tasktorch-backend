DocumentStatus = require 'data/DocumentStatus'

class Note

  constructor: (@type, @card, @user, @content = {}) ->
    @time = new Date()

module.exports = Note
