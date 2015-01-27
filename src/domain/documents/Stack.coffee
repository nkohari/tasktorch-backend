Document = require './Document'

class Stack extends Document

  constructor: (data) ->
    super(data)
    @organization = data.organization
    @type         = data.type
    @name         = data.name if data.name?
    @user         = data.user if data.user?
    @team         = data.team if data.team?
    @cards        = data.cards ? []

module.exports = Stack
