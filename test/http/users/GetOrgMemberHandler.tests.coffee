_                   = require 'lodash'
expect              = require('chai').expect
TestHarness         = require 'test/framework/TestHarness'
CommonBehaviors     = require 'test/framework/CommonBehaviors'
GetOrgMemberHandler = require 'http/handlers/users/GetOrgMemberHandler'

describe 'GetOrgMemberHandler', ->

#---------------------------------------------------------------------------------------------------

  before ->
    @tester = TestHarness.createTester(GetOrgMemberHandler)

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', userid: 'user-frank'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', userid: 'user-frank', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent user', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', userid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid user in an org of which the requester is a member', ->
    it 'returns the user', (done) ->
      @tester.request {orgid: 'org-paddys', userid: 'user-frank', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {user} = res.body
        expect(user).to.exist()
        expect(user.id).to.equal('user-frank')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', userid: 'user-greg', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and userid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', userid: 'user-greg', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
