Model  = require 'domain/framework/Model'

class ProfileModel extends Model

  constructor: (profile) ->
    super(profile)
    @bio      = profile.bio
    @title    = profile.title
    @contacts = profile.contacts
    @user     = profile.user
    @org      = profile.org

module.exports = ProfileModel
