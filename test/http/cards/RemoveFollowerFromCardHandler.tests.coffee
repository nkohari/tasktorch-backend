_                             = require 'lodash'
expect                        = require('chai').expect
TestData                      = require 'test/framework/TestData'
TestHarness                   = require 'test/framework/TestHarness'
CommonBehaviors               = require 'test/framework/CommonBehaviors'
RemoveFollowerFromCardHandler = require 'apps/api/handlers/cards/RemoveFollowerFromCardHandler'

describe 'RemoveFollowerFromCardHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(RemoveFollowerFromCardHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['cards', 'notes'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', cardid: 'card-takedbaby', userid: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    orgid  = 'doesnotexist'
    cardid = 'card-takedbaby'
    userid = 'user-charlie'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent card', ->
    orgid  = 'org-paddys'
    cardid = 'doesnotexist'
    userid = 'user-charlie'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a user argument other than the requester', ->
    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'
    userid = 'user-dee'
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a card with the userid of the requester and an org of which the requester is a member', ->
    orgid  = 'org-paddys'
    cardid = 'card-takedbaby'
    userid = 'user-charlie'
    it 'removes the user as a follower', (done) ->
      @tester.request {orgid, cardid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {card} = res.result
        expect(card).to.exist()
        expect(card.id).to.equal(cardid)
        expect(card.followers).not.to.contain(userid)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid  = 'org-sudz'
    cardid = 'card-ringbell'
    userid = 'user-charlie'
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, cardid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->
    orgid  = 'org-paddys'
    cardid = 'card-ringbell'
    userid = 'user-charlie'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, cardid, userid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
