exports.Card = require './Card'
exports.Organization = require './Organization'
exports.Session = require './Session'
exports.Stack = require './Stack'
exports.Team = require './Team'
exports.User = require './User'

exports.getSchema = (name) ->
  exports[name].schema
