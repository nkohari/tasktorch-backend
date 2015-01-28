_                          = require 'lodash'
expect                     = require('chai').expect
TestHarness                = require 'test/framework/TestHarness'
CommonBehaviors            = require 'test/framework/CommonBehaviors'
ListFollowersByCardHandler = require 'http/handlers/users/ListFollowersByCardHandler'

describe 'ListFollowersByCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before ->
    @tester = TestHarness.createTester(ListFollowersByCardHandler)

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', cardid: 'card-takedbaby'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', cardid: 'card-takedbaby', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', cardid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid card in an org of which the requester is a member', ->
    it 'returns an array of users currently following the card', (done) ->
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.body).to.exist()
        {users} = res.body
        expect(users).to.exist()
        expect(users).to.have.length(3)
        expect(_.pluck(users, 'id')).to.have.members ['user-charlie', 'user-dee', 'user-mac']
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', cardid: 'card-ringbell', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', cardid: 'card-ringbell', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
